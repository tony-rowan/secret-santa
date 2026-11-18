require "rails_helper"

RSpec.describe Group do
  describe "#remove_pairings" do
    it "removes only this group's pairings" do
      owner, member = create_list(:user, 2)
      group = create(:group, owner:, users: [owner, member])
      other_group = create(:group, owner:, users: [owner, member])
      create(:pair, group:, user: owner, other: member)
      other_pair = create(:pair, group: other_group, user: owner, other: member)

      group.remove_pairings

      expect(group.pairs).to be_empty
      expect(other_group.pairs).to eq([other_pair])
    end
  end

  describe "#remove_ideas" do
    it "removes this group's ideas from every member" do
      owner, member = create_list(:user, 2)
      group = create(:group, owner:, users: [owner, member])
      other_group = create(:group, owner:, users: [owner, member])
      create(:idea, group:, user: owner)
      create(:idea, group:, user: member)
      other_idea = create(:idea, group: other_group, user: owner)

      group.remove_ideas

      expect(group.ideas).to be_empty
      expect(other_group.ideas).to eq([other_idea])
    end
  end
end
