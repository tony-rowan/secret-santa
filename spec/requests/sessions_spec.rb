require "rails_helper"

RSpec.describe "Sessions" do
  describe "POST /session" do
    context "when the email is typed in a different case" do
      it "signs the user in" do
        create(:user, email: "trevor@example.com", password: "the_mandarin")

        post session_path, params: {email: " Trevor@Example.COM ", password: "the_mandarin"}

        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when the email is unknown" do
      it "re-renders the form as unprocessable" do
        post session_path, params: {email: "nobody@example.com", password: "password"}

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
