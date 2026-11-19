require "rails_helper"

RSpec.describe "Email confirmations" do
  def pending_user(**attrs)
    create(:user, email: "old@example.com", unconfirmed_email: "new@example.com", **attrs)
  end

  describe "GET /email_confirmation" do
    context "when the token is valid" do
      it "asks for confirmation without applying the change" do
        user = pending_user

        get email_confirmation_path(token: user.generate_token_for(:email_change))

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Confirming your new email")
        expect(user.reload).to have_attributes(email: "old@example.com", unconfirmed_email: "new@example.com")
      end
    end
  end

  describe "POST /email_confirmation" do
    context "when the token is valid and the user is signed in" do
      it "applies the change and redirects to the dashboard" do
        user = pending_user

        authenticate(user)
        post email_confirmation_path, params: {token: user.generate_token_for(:email_change)}

        expect(response).to redirect_to(dashboard_path)
        expect(flash[:success]).to eq("Email updated")
        expect(user.reload).to have_attributes(email: "new@example.com", unconfirmed_email: nil)
      end
    end

    context "when the token is valid and the user is signed out" do
      it "applies the change and redirects to sign in" do
        user = pending_user

        post email_confirmation_path, params: {token: user.generate_token_for(:email_change)}

        expect(response).to redirect_to(new_session_path)
        expect(flash[:success]).to eq("Email updated")
        expect(user.reload.email).to eq("new@example.com")
      end
    end

    context "when the token has expired" do
      it "is rejected" do
        user = pending_user
        token = user.generate_token_for(:email_change)

        travel(61.minutes) do
          post email_confirmation_path, params: {token:}
        end

        expect(response).to redirect_to(new_session_path)
        expect(flash[:error]).to include("expired")
        expect(user.reload.email).to eq("old@example.com")
      end
    end

    context "when the token has been superseded" do
      it "is rejected" do
        user = pending_user
        token = user.generate_token_for(:email_change)
        user.update!(unconfirmed_email: "newer@example.com")

        post email_confirmation_path, params: {token:}

        expect(response).to redirect_to(new_session_path)
        expect(flash[:error]).to include("expired")
        expect(user.reload.email).to eq("old@example.com")
      end
    end

    context "when the address was taken in the meantime" do
      it "clears the pending change and explains" do
        user = pending_user
        token = user.generate_token_for(:email_change)
        create(:user, email: "new@example.com")

        post email_confirmation_path, params: {token:}

        expect(response).to redirect_to(new_session_path)
        expect(flash[:error]).to include("another account")
        expect(user.reload).to have_attributes(email: "old@example.com", unconfirmed_email: nil)
      end
    end
  end

  describe "DELETE /email_confirmation" do
    context "when signed in with a pending change" do
      it "cancels the change" do
        user = pending_user

        authenticate(user)
        delete email_confirmation_path

        expect(response).to redirect_to(edit_user_path(user))
        expect(user.reload.unconfirmed_email).to be_nil
      end
    end

    context "when signed out" do
      it "redirects to the root" do
        delete email_confirmation_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /email_confirmation/resend" do
    context "when signed in with a pending change" do
      it "sends the link to the new address again" do
        user = pending_user

        authenticate(user)
        post resend_email_confirmation_path

        expect(response).to redirect_to(edit_user_path(user))
        expect(ActionMailer::Base.deliveries.last.to).to eq(["new@example.com"])
      end
    end

    context "when there's no pending change" do
      it "sends nothing" do
        user = create(:user)

        authenticate(user)
        post resend_email_confirmation_path

        expect(response).to redirect_to(edit_user_path(user))
        expect(flash[:error]).to be_present
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
