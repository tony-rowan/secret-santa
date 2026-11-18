require "rails_helper"

RSpec.describe "GET /dashboard" do
  context "when signed in" do
    it "links to the account page from the header" do
      user = create(:user)

      authenticate(user)
      get dashboard_path

      expect(response.body).to include(%(href="#{edit_user_path(user)}"))
    end
  end

  context "when the user owns the group" do
    it "shows the group name and owner actions in the group menu" do
      owner = create(:user)
      group = create(:group, owner:, name: "Elf Squad")

      authenticate(owner)
      get dashboard_path
      menu = Capybara.string(response.body).find("nav[aria-label='Group']")

      expect(menu).to have_css("h2", text: "Elf Squad")
      expect(menu).to have_link("Manage Group", href: edit_group_path(group))
      expect(menu).to have_link("Invite Others")
      expect(menu).to have_button("Assign Secret Santa Partners")
      expect(menu).to have_no_button("Leave group")
    end
  end

  context "when the user is a member but not the owner" do
    it "shows only the leave action in the group menu" do
      group = create(:group, name: "Elf Squad")
      member = create(:user)
      group.users << member

      authenticate(member)
      get dashboard_path
      menu = Capybara.string(response.body).find("nav[aria-label='Group']")

      expect(menu).to have_button("Leave Elf Squad")
      expect(menu).to have_no_link("Manage Group")
      expect(menu).to have_no_link("Invite Others")
      expect(menu).to have_no_button("Assign Secret Santa Partners")
    end
  end

  context "when the group has no rules" do
    it "does not render the Rules box" do
      owner = create(:user)
      create(:group, owner:, rules: nil)

      authenticate(owner)
      get dashboard_path

      expect(Capybara.string(response.body)).to have_no_css("h3", text: "Rules")
    end
  end

  context "when the group has rules" do
    it "renders the Rules box" do
      owner = create(:user)
      create(:group, owner:, rules: "No spending over $20")

      authenticate(owner)
      get dashboard_path

      expect(Capybara.string(response.body)).to have_css("h3", text: "Rules")
    end
  end
end
