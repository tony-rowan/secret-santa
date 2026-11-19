require "rails_helper"

RSpec.describe Group do
  describe "#reset" do
    it "removes this group's pairings and ideas only" do
      owner, member = create_list(:user, 2)
      group = create(:group, owner:, users: [owner, member])
      other_group = create(:group, owner:, users: [owner, member])
      create(:pair, group:, user: owner, other: member)
      create(:idea, group:, user: owner)
      create(:idea, group:, user: member)
      other_pair = create(:pair, group: other_group, user: owner, other: member)
      other_idea = create(:idea, group: other_group, user: owner)

      group.reset

      expect(group.pairs).to be_empty
      expect(group.ideas).to be_empty
      expect(other_group.pairs).to eq([other_pair])
      expect(other_group.ideas).to eq([other_idea])
    end

    it "keeps the members and rules" do
      owner, member = create_list(:user, 2)
      group = create(:group, owner:, users: [owner, member])
      rule = group.rules.create!(text: "Keep it under £20")

      group.reset

      expect(group.reload.users).to contain_exactly(owner, member)
      expect(group.rules).to eq([rule])
    end
  end

  describe "#rules" do
    it "keeps the order they were added in" do
      group = create(:group)
      first = group.rules.create!(text: "Keep it under £20")
      second = group.rules.create!(text: "Swap gifts on Christmas Eve")

      expect(group.reload.rules).to eq([first, second])
    end
  end
end
