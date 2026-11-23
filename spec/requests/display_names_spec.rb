require "rails_helper"

RSpec.describe "Display names" do
  describe "GET /display_name/new" do
    context "when the user has no name yet" do
      it "asks for one" do
        authenticate(create(:user, name: nil))

        get new_display_name_path

        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user already has a name" do
      it "redirects to the dashboard" do
        authenticate(create(:user))

        get new_display_name_path

        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when signed out" do
      it "redirects to sign in" do
        get new_display_name_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /display_name" do
    context "when a name is given" do
      it "saves it and goes on to join a group" do
        user = create(:user, name: nil)

        authenticate(user)
        post display_name_path, params: {user: {name: "Trevor Slattery"}}

        expect(user.reload.name).to eq("Trevor Slattery")
        expect(response).to redirect_to(join_path)
      end
    end

    context "when the user arrived from an invite link" do
      it "goes on to the join page" do
        create(:group, join_code: "ABCDEF")
        user = create(:user, name: nil)

        authenticate(user)
        get join_with_code_path("ABCDEF")
        post display_name_path, params: {user: {name: "Trevor Slattery"}}

        expect(response).to redirect_to(join_path)
        follow_redirect!
        expect(Capybara.string(response.body)).to have_css("h1", text: "You're invited")
      end
    end

    context "when the name is blank" do
      it "re-renders the form as unprocessable" do
        user = create(:user, name: nil)

        authenticate(user)
        post display_name_path, params: {user: {name: " "}}

        expect(response).to have_http_status(:unprocessable_content)
        expect(user.reload.name).to be_nil
      end
    end
  end
end
