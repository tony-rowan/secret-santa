require "rails_helper"

RSpec.describe "Sessions" do
  describe "GET /" do
    it "shows the sign in page" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(Capybara.string(response.body)).to have_title("Secret Santa by muddle")
    end

    it "links to the privacy policy and terms" do
      get root_path

      page = Capybara.string(response.body)
      expect(page).to have_link("Privacy", href: privacy_path)
      expect(page).to have_link("Terms", href: terms_path)
    end

    context "when signed in" do
      it "redirects to the dashboard" do
        authenticate(create(:user))

        get root_path

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "GET /session/new" do
    it "shows the sign in page" do
      get new_session_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /session" do
    context "when the email belongs to a user" do
      it "sends exactly one sign-in link and asks the user to check their email" do
        user = create(:user, email: "trevor@example.com")

        post session_path, params: {email: "trevor@example.com"}

        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
        expect(response).to have_http_status(:ok)
        expect(Capybara.string(response.body)).to have_css("h1", text: "Check your email")
        expect(Capybara.string(response.body)).to have_css("form[action='#{session_path}'] input[name='email'][value='trevor@example.com']", visible: :all)
      end
    end

    context "when the email is typed in a different case" do
      it "still sends the sign-in link" do
        create(:user, email: "trevor@example.com")

        post session_path, params: {email: " Trevor@Example.COM "}

        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
    end

    context "when the email is unknown" do
      it "sends a sign-up link and renders the same page without creating an account" do
        post session_path, params: {email: " Nobody@Example.com "}

        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["nobody@example.com"])
        expect(User.count).to eq(0)
        expect(response).to have_http_status(:ok)
        expect(Capybara.string(response.body)).to have_css("h1", text: "Check your email")
      end
    end

    context "when the email is invalid" do
      it "re-renders the form with an error and sends nothing" do
        post session_path, params: {email: "not an email"}

        expect(response).to have_http_status(:unprocessable_content)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when the user started from a join link" do
      it "carries the join code in the emailed link" do
        create(:user, email: "trevor@example.com")
        create(:group, join_code: "ABCDEF")

        get join_with_code_path("ABCDEF")
        post session_path, params: {email: "trevor@example.com"}

        expect(last_magic_link_url).to include("join_code=ABCDEF")
      end
    end
  end

  describe "POST /session rate limiting" do
    context "when one IP exceeds its limit" do
      it "explains on the sign-in page and sends no further email" do
        10.times do |i|
          create(:user, email: "user#{i}@example.com")
          post session_path, params: {email: "user#{i}@example.com"}
        end
        create(:user, email: "extra@example.com")
        ActionMailer::Base.deliveries.clear

        post session_path, params: {email: "extra@example.com"}

        expect(response).to have_http_status(:too_many_requests)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when one email exceeds its limit" do
      it "explains on the sign-in page and sends no further email to it" do
        create(:user, email: "trevor@example.com")
        create(:user, email: "other@example.com")

        3.times { post session_path, params: {email: " Trevor@example.com "} }
        ActionMailer::Base.deliveries.clear
        post session_path, params: {email: "trevor@example.com"}

        expect(response).to have_http_status(:too_many_requests)
        expect(ActionMailer::Base.deliveries).to be_empty

        post session_path, params: {email: "other@example.com"}

        expect(response).to have_http_status(:ok)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
    end
  end

  describe "DELETE /session" do
    it "signs the user out" do
      authenticate(create(:user))

      delete session_path
      get dashboard_path

      expect(response).to redirect_to(root_path)
    end
  end
end
