require "rails_helper"

RSpec.describe "Sessions" do
  describe "GET /session/new" do
    it "asks only for an email" do
      get new_session_path

      expect(response.body).to include("Email me a sign-in link")
      expect(response.body).not_to include("Password")
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
        expect(response.body).to include("Check your email")
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
      it "sends nothing but renders the same page" do
        post session_path, params: {email: "nobody@example.com"}

        expect(ActionMailer::Base.deliveries).to be_empty
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Check your email")
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
      it "redirects with an error and sends no further email" do
        10.times do |i|
          create(:user, email: "user#{i}@example.com")
          post session_path, params: {email: "user#{i}@example.com"}
        end
        create(:user, email: "extra@example.com")
        ActionMailer::Base.deliveries.clear

        post session_path, params: {email: "extra@example.com"}

        expect(response).to redirect_to(new_session_path)
        expect(flash[:error]).to eq(ApplicationController::RATE_LIMIT_MESSAGE)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when one email exceeds its limit" do
      it "redirects with an error and sends no further email to it" do
        create(:user, email: "trevor@example.com")
        create(:user, email: "other@example.com")

        3.times { post session_path, params: {email: " Trevor@example.com "} }
        ActionMailer::Base.deliveries.clear
        post session_path, params: {email: "trevor@example.com"}

        expect(response).to redirect_to(new_session_path)
        expect(flash[:error]).to eq(ApplicationController::RATE_LIMIT_MESSAGE)
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
