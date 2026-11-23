require "rails_helper"

RSpec.describe Dashboard::StatusComponent, type: :component do
  context "when names have been drawn" do
    it "shows who the user is buying for" do
      owner = create(:user)
      match = create(:user, name: "Alex")
      group = create(:group, owner:, users: [owner, match, create(:user)])
      pair = create(:pair, group:, user: owner, other: match)

      render_inline(described_class.new(group:, user: owner, pair:, idea_counts: {}))

      expect(page).to have_text("You're buying for")
      expect(page).to have_css("h2", text: "Alex")
    end
  end

  context "when names haven't been drawn and the user is the organiser" do
    it "offers the draw" do
      owner = create(:user)
      group = create(:group, owner:, users: [owner, *create_list(:user, 2)])

      render_inline(described_class.new(group:, user: owner, pair: nil, idea_counts: {}))

      expect(page).to have_text("Ready when you are")
      expect(page).to have_button("Draw names")
    end
  end

  context "when names haven't been drawn and the user is a member" do
    it "shows the steps without the draw" do
      member = create(:user)
      group = create(:group, users: [member])

      render_inline(described_class.new(group:, user: member, pair: nil, idea_counts: {member.id => 2}))

      expect(page).to have_text("Waiting for the draw")
      expect(page).to have_no_button("Draw names")
      expect(page).to have_css("li[aria-current='step']", text: "Names drawn")
    end
  end
end
