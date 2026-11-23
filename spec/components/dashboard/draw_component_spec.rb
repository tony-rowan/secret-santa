require "rails_helper"

RSpec.describe Dashboard::DrawComponent, type: :component do
  it "shows how many members have added ideas" do
    owner, member = create_list(:user, 2)
    group = create(:group, owner:, users: [owner, member, create(:user)])

    render_inline(described_class.new(group:, idea_counts: {owner.id => 1, member.id => 3}))

    expect(page).to have_text("Members with ideas 2 of 3")
    expect(page).to have_css("span[style='width: 66%']")
  end

  context "when the group has fewer than 3 members" do
    it "disables the draw and explains why" do
      owner = create(:user)
      group = create(:group, owner:, users: [owner, create(:user)])

      render_inline(described_class.new(group:, idea_counts: {}))

      expect(page).to have_button("Draw names", disabled: true)
      expect(page).to have_text("You need at least 3 people to draw names")
    end
  end

  context "when the group has 3 or more members" do
    it "enables the draw" do
      owner = create(:user)
      group = create(:group, owner:, users: [owner, *create_list(:user, 2)])

      render_inline(described_class.new(group:, idea_counts: {}))

      expect(page).to have_button("Draw names", disabled: false)
      expect(page).to have_css("input[name='assign_partners']", visible: :all)
      expect(page).to have_text("Everyone gets one random person. You won't see who has who.")
    end
  end
end
