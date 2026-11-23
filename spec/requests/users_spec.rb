require "rails_helper"

RSpec.describe "Users" do
  describe "GET /users/:id/edit" do
    context "when the authenticated user is the requested user" do
      it "renders the edit form" do
        user = create(:user)

        authenticate(user)
        get edit_user_path(user)

        expect(response).to have_http_status(:ok)
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
      it "saves it immediately and returns to the account page" do
        user = create(:user)

        authenticate(user)
        patch user_path(user), params: {user: {name: "New Name"}}

        expect(user.reload.name).to eq("New Name")
        expect(response).to redirect_to(edit_user_path(user))
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when the email changes" do
      it "holds the new address pending and leaves the email alone" do
        user = create(:user, email: "old@example.com")

        authenticate(user)
        patch user_path(user), params: {user: {email: "new@example.com"}}

        expect(user.reload).to have_attributes(email: "old@example.com", unconfirmed_email: "new@example.com")
        expect(response).to redirect_to(edit_user_path(user))
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
        patch user_path(user), params: {user: {name: ""}}

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when too many email changes are requested" do
      it "explains on the account page and holds nothing new" do
        user = create(:user)

        authenticate(user)
        5.times do |i|
          patch user_path(user), params: {user: {name: user.name, email: "new#{i}@example.com"}}
        end
        patch user_path(user), params: {user: {name: user.name, email: "extra@example.com"}}

        expect(response).to have_http_status(:too_many_requests)
        expect(user.reload.unconfirmed_email).to eq("new4@example.com")
      end
    end

    context "when many name-only changes are made" do
      it "is not rate limited" do
        user = create(:user)

        authenticate(user)
        7.times do |i|
          patch user_path(user), params: {user: {name: "Name #{i}"}}
        end

        expect(response).to redirect_to(edit_user_path(user))
      end
    end
  end

  describe "DELETE /users/:id" do
    it "deletes the account, signs out and returns to the sign-in page" do
      user = create(:user)

      authenticate(user)
      delete user_path(user)

      expect(User.exists?(user.id)).to be(false)
      expect(response).to redirect_to(root_path)

      get dashboard_path
      expect(response).to redirect_to(root_path)
    end

    context "when the user is someone else" do
      it "leaves the account alone" do
        user = create(:user)

        authenticate(create(:user))
        delete user_path(user)

        expect(User.exists?(user.id)).to be(true)
      end
    end
  end
end
