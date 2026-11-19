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
    context "when only the name changes" do
      it "saves it immediately and redirects to the dashboard" do
        user = create(:user)

        authenticate(user)
        patch user_path(user), params: {user: {name: "New Name", email: user.email}}

        expect(user.reload.name).to eq("New Name")
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:success]).to eq(["Account updated"])
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when the email changes" do
      it "holds the new address pending and leaves the email alone" do
        user = create(:user, email: "old@example.com")

        authenticate(user)
        patch user_path(user), params: {user: {name: user.name, email: "new@example.com"}}

        expect(user.reload).to have_attributes(email: "old@example.com", unconfirmed_email: "new@example.com")
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:notice].first).to include("new@example.com")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["new@example.com"])
      end
    end

    context "when the new address is taken" do
      it "re-renders the form as unprocessable without sending anything" do
        user = create(:user)
        other = create(:user)

        authenticate(user)
        patch user_path(user), params: {user: {name: user.name, email: other.email}}

        expect(response).to have_http_status(:unprocessable_content)
        expect(user.reload.unconfirmed_email).to be_nil
        expect(ActionMailer::Base.deliveries).to be_empty
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

    context "when too many email changes are requested" do
      it "redirects back to the edit page with an error" do
        user = create(:user)

        authenticate(user)
        5.times do |i|
          patch user_path(user), params: {user: {name: user.name, email: "new#{i}@example.com"}}
        end
        patch user_path(user), params: {user: {name: user.name, email: "extra@example.com"}}

        expect(response).to redirect_to(edit_user_path(user))
        expect(flash[:error]).to eq(ApplicationController::RATE_LIMIT_MESSAGE)
        expect(user.reload.unconfirmed_email).to eq("new4@example.com")
      end
    end

    context "when many name-only changes are made" do
      it "is not rate limited" do
        user = create(:user)

        authenticate(user)
        7.times do |i|
          patch user_path(user), params: {user: {name: "Name #{i}", email: user.email}}
        end

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
