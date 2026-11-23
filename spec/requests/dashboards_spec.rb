require "rails_helper"

# What the dashboard shows for each kind of user is covered by the components in spec/components/dashboard
RSpec.describe "GET /dashboard" do
  context "when the user is in a group" do
    it "shows it" do
      user = create(:user)
      create(:group, name: "Rowans", owner: user)

      authenticate(user)
      get dashboard_path

      expect(response).to have_http_status(:ok)
      expect(Capybara.string(response.body)).to have_css("h1", text: "Rowans")
    end
  end

  context "when the user isn't in any group" do
    it "sends them to join one" do
      authenticate(create(:user))

      get dashboard_path

      expect(response).to redirect_to(join_path)
    end
  end

  context "when the user has no display name yet" do
    it "asks for one first" do
      authenticate(create(:user, name: nil))

      get dashboard_path

      expect(response).to redirect_to(new_display_name_path)
    end
  end

  context "when a group is chosen" do
    it "shows that group from then on" do
      user = create(:user)
      first = create(:group, name: "Book club", users: [user])
      create(:group, name: "Rowans", owner: user)

      authenticate(user)
      get dashboard_path(group_id: first.id)
      expect(Capybara.string(response.body)).to have_css("h1", text: "Book club")

      get dashboard_path
      expect(Capybara.string(response.body)).to have_css("h1", text: "Book club")
    end
  end

  context "when the chosen group isn't one of the user's" do
    it "ignores it" do
      user = create(:user)
      create(:group, name: "Rowans", owner: user)
      other = create(:group, name: "Strangers")

      authenticate(user)
      get dashboard_path(group_id: other.id)

      expect(Capybara.string(response.body)).to have_css("h1", text: "Rowans")
      expect(response.body).not_to include("Strangers")
    end
  end
end
