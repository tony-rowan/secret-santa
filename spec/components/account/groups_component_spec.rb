require "rails_helper"

RSpec.describe Account::GroupsComponent, type: :component do
  context "when the user is in groups" do
    it "lists them and offers to join another" do
      user = create(:user)
      group = create(:group, name: "Rowans", owner: user)

      render_inline(described_class.new(user:, groups: [group]))

      expect(page).to have_link(href: "/dashboard?group_id=#{group.id}", text: "Rowans")
      expect(page).to have_link("Join another group", href: "/join")
      expect(page).to have_no_text("No groups yet")
    end
  end

  context "when the user has no groups" do
    it "shows the empty state and ways to get started" do
      render_inline(described_class.new(user: create(:user), groups: []))

      expect(page).to have_text("No groups yet")
      expect(page).to have_link("Join a group", href: "/join")
      expect(page).to have_link("Start a new group", href: "/groups/new")
    end
  end
end
