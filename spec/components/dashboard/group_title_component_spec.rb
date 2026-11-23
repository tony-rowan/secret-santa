require "rails_helper"

RSpec.describe Dashboard::GroupTitleComponent, type: :component do
  context "when the user is in one group" do
    it "shows just the group name" do
      user = create(:user)
      group = create(:group, name: "Rowans", owner: user)

      render_inline(described_class.new(group:, groups: [group], user:))

      expect(page).to have_css("h1", text: "Rowans")
      expect(page).to have_no_css("details", visible: :all)
    end
  end

  context "when the user is in several groups" do
    it "offers to switch between them, marking the current one" do
      user = create(:user)
      rowans = create(:group, name: "Rowans", owner: user)
      book_club = create(:group, name: "Book club", owner: create(:user, name: "Sam"), users: [user])

      render_inline(described_class.new(group: rowans, groups: [book_club, rowans], user:))

      switcher = page.find("details", visible: :all)
      expect(switcher).to have_css("summary[aria-label='Rowans, switch group'] h1", text: "Rowans", visible: :all)
      expect(switcher).to have_link("Book club", href: "/dashboard?group_id=#{book_club.id}", visible: :all)
      expect(switcher).to have_css("a[aria-current='true']", text: "Rowans", visible: :all)
      expect(switcher).to have_css("a[aria-current='false']", text: "Book club", visible: :all)
      expect(switcher).to have_link("Join another group", href: "/join", visible: :all)
    end

    it "says who organises each group" do
      user = create(:user)
      rowans = create(:group, name: "Rowans", owner: user)
      book_club = create(:group, name: "Book club", owner: create(:user, name: "Sam"), users: [user])

      render_inline(described_class.new(group: rowans, groups: [book_club, rowans], user:))

      expect(page).to have_css("a", text: /Rowans\s+Organised by you/, visible: :all)
      expect(page).to have_css("a", text: /Book club\s+Organised by Sam/, visible: :all)
    end
  end
end
