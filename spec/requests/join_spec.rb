require "rails_helper"

# What each page shows is covered by the components in spec/components/join
RSpec.describe "Join" do
  describe "GET /join" do
    it "sends them to start a group" do
      authenticate(create(:user))

      get join_path

      expect(response).to redirect_to(new_group_path)
    end

    context "when signed out" do
      it "redirects to sign in" do
        get join_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /join/:invite_token" do
    context "when the token matches a group" do
      it "shows the invitation" do
        group = create(:group, name: "Rowans")
        authenticate(create(:user))

        get invite_path(group.invite_token)

        page = Capybara.string(response.body)
        expect(page).to have_css("h1", text: "You're invited")
        expect(page).to have_button("Join Rowans")
      end
    end

    context "when the user is already a member" do
      it "shows them the group" do
        user = create(:user)
        group = create(:group, users: [user])
        authenticate(user)

        get invite_path(group.invite_token)

        expect(response).to redirect_to(dashboard_path)
        expect(session[:group_id]).to eq(group.id)
      end
    end

    context "when names have been drawn" do
      it "says the group isn't taking new members" do
        group = create(:group)
        create(:pair, group:, user: group.owner, other: create(:user))
        authenticate(create(:user))

        get invite_path(group.invite_token)

        expect(response).to have_http_status(:forbidden)
        expect(Capybara.string(response.body)).to have_css("h1", text: "Names have been drawn")
      end
    end

    context "when the token doesn't match a group" do
      it "says the link doesn't work" do
        authenticate(create(:user))

        get invite_path("NOPE")

        expect(response).to have_http_status(:not_found)
        expect(Capybara.string(response.body)).to have_css("h1", text: "That invite link doesn't work")
      end
    end

    context "when signed out" do
      it "keeps the token for after signing in" do
        group = create(:group)

        get invite_path(group.invite_token)

        expect(response).to redirect_to(root_path)
        expect(session[:invite_token]).to eq(group.invite_token)
      end
    end
  end

  describe "POST /join" do
    it "joins the group and shows it" do
      user = create(:user)
      group = create(:group)
      authenticate(user)

      post join_path, params: {join_group: {invite_token: group.invite_token}}

      expect(group.reload.users).to include(user)
      expect(response).to redirect_to(dashboard_path)
    end

    context "when names have been drawn" do
      it "doesn't join and says the group isn't taking new members" do
        user = create(:user)
        group = create(:group)
        create(:pair, group:, user: group.owner, other: create(:user))
        authenticate(user)

        post join_path, params: {join_group: {invite_token: group.invite_token}}

        expect(group.reload.users).not_to include(user)
        expect(response).to have_http_status(:forbidden)
        expect(Capybara.string(response.body)).to have_css("h1", text: "Names have been drawn")
      end
    end

    context "when the token doesn't match a group" do
      it "says the link doesn't work" do
        authenticate(create(:user))

        post join_path, params: {join_group: {invite_token: "NOPE"}}

        expect(response).to have_http_status(:not_found)
        expect(Capybara.string(response.body)).to have_css("h1", text: "That invite link doesn't work")
      end
    end
  end
end
