require "rails_helper"

# What each page shows is covered by the components in spec/components/join
RSpec.describe "Join" do
  describe "GET /join" do
    it "asks for a code" do
      authenticate(create(:user))

      get join_path

      expect(response).to have_http_status(:ok)
      expect(Capybara.string(response.body)).to have_css("h1", text: "Join a group")
    end

    context "when signed out" do
      it "redirects to sign in" do
        get join_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /join/:join_code" do
    context "when the code matches a group" do
      it "shows the invitation" do
        create(:group, name: "Rowans", join_code: "ABCDEF")
        authenticate(create(:user))

        get join_with_code_path("abc-def")

        page = Capybara.string(response.body)
        expect(page).to have_css("h1", text: "You're invited")
        expect(page).to have_button("Join Rowans")
      end
    end

    context "when the code doesn't match a group" do
      it "asks for a code" do
        authenticate(create(:user))

        get join_with_code_path("NOPE")

        expect(Capybara.string(response.body)).to have_css("h1", text: "Join a group")
      end
    end
  end

  describe "POST /join" do
    it "joins the group and shows it" do
      user = create(:user)
      group = create(:group, join_code: "ABCDEF")
      authenticate(user)

      post join_path, params: {join_group: {join_code: "abcd-ef"}}

      expect(group.reload.users).to include(user)
      expect(response).to redirect_to(dashboard_path)
    end

    context "when the code doesn't match a group" do
      it "re-renders the form as unprocessable" do
        authenticate(create(:user))

        post join_path, params: {join_group: {join_code: "NOPE"}}

        expect(response).to have_http_status(:unprocessable_content)
        expect(Capybara.string(response.body)).to have_css("h1", text: "Join a group")
      end
    end
  end
end
