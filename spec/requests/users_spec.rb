require "rails_helper"

RSpec.describe "Users" do
  describe "POST /users" do
    context "when the params are valid" do
      it "sends a sign-in link and does not sign the user in" do
        post users_path, params: {user: {name: "Trevor Slattery", email: "trevor@example.com"}}

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Check your email")
        expect(User.last).to have_attributes(name: "Trevor Slattery", email: "trevor@example.com")
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["trevor@example.com"])

        get dashboard_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the params are invalid" do
      it "re-renders the form as unprocessable without sending anything" do
        post users_path, params: {user: {name: "", email: "trevor@example.com"}}

        expect(response).to have_http_status(:unprocessable_content)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

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
        patch user_path(user), params: {user: {name: "New Name", email: "new@example.com"}}

        expect(user.reload).to have_attributes(name: "New Name", email: "new@example.com")
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when the params are invalid" do
      it "re-renders the form as unprocessable" do
        user = create(:user)

        authenticate(user)
        patch user_path(user), params: {user: {name: "", email: user.email}}

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Edit your account")
      end
    end
  end
end
