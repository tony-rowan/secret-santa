require "rails_helper"

RSpec.describe "Users" do
  describe "GET /users/:id/edit" do
    context "when the authenticated user is the requested user" do
      it "renders the edit form" do
        user = create(:user)

        authenticate(user)
        get edit_user_path(user)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Edit your account")
      end
    end

    context "when the authenticated user is a different user" do
      it "redirects to the root" do
        user = create(:user)

        authenticate(create(:user))
        get edit_user_path(user)

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /users/:id" do
    context "when the params are valid" do
      it "updates the user and redirects to the dashboard" do
        user = create(:user)

        authenticate(user)
        patch user_path(user), params: {user: {name: "New Name", login: "new_login", password: ""}}

        expect(user.reload).to have_attributes(name: "New Name", login: "new_login")
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when the password is left blank" do
      it "keeps the current password" do
        user = create(:user, password: "original")

        authenticate(user)
        patch user_path(user), params: {user: {name: user.name, login: user.login, password: ""}}

        expect(user.reload.authenticate("original")).to eq(user)
      end
    end

    context "when the params are invalid" do
      it "re-renders the form as unprocessable" do
        user = create(:user)

        authenticate(user)
        patch user_path(user), params: {user: {name: "", login: user.login}}

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Edit your account")
      end
    end
  end
end
