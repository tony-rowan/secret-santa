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

  describe "DELETE /session" do
    it "signs the user out" do
      authenticate(create(:user))

      delete session_path
      get dashboard_path

      expect(response).to redirect_to(root_path)
    end
  end
end
