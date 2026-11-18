require "rails_helper"

RSpec.describe "Magic links" do
  describe "GET /session/magic_link" do
    context "when the token is valid" do
      it "asks for confirmation without signing in" do
        user = create(:user, name: "Trevor Slattery")

        get session_magic_link_path(token: user.generate_token_for(:sign_in))

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Signing you in")

        get dashboard_path
        expect(response).to redirect_to(root_path)
        expect(user.reload.last_signed_in_at).to be_nil
      end
    end

    context "when the token is garbage" do
      it "redirects to the sign in page with an error" do
        get session_magic_link_path(token: "garbage")

        expect(response).to redirect_to(new_session_path)
        expect(flash[:error]).to include("expired or already been used")
      end
    end
  end

  describe "POST /session/magic_link" do
    context "when the token is valid" do
      it "signs the user in and redirects to the dashboard" do
        user = create(:user)

        post session_magic_link_path, params: {token: user.generate_token_for(:sign_in)}

        expect(response).to redirect_to(dashboard_path)
        expect(flash[:success]).to eq("Signed In")
        expect(user.reload.last_signed_in_at).to be_present

        get dashboard_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a join code is given" do
      it "redirects to the join page" do
        user = create(:user)

        post session_magic_link_path, params: {token: user.generate_token_for(:sign_in), join_code: "ABCDEF"}

        expect(response).to redirect_to(join_with_code_path("ABCDEF"))
      end
    end

    context "when the token has expired" do
      it "is rejected" do
        user = create(:user)
        token = user.generate_token_for(:sign_in)

        travel(16.minutes) do
          post session_magic_link_path, params: {token:}
        end

        expect(response).to redirect_to(new_session_path)
        expect(flash[:error]).to include("expired or already been used")
        expect(user.reload.last_signed_in_at).to be_nil
      end
    end

    context "when the token has already been used" do
      it "is rejected" do
        user = create(:user)
        token = user.generate_token_for(:sign_in)

        post session_magic_link_path, params: {token:}
        delete session_path
        post session_magic_link_path, params: {token:}

        expect(response).to redirect_to(new_session_path)
        get dashboard_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the token is garbage" do
      it "is rejected" do
        post session_magic_link_path, params: {token: "garbage"}

        expect(response).to redirect_to(new_session_path)
        get dashboard_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
