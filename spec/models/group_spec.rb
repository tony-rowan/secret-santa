require "rails_helper"

RSpec.describe Group do
  describe "#invite_token" do
    it "is 24 random base58 characters" do
      expect(create(:group).invite_token).to match(/\A[1-9A-HJ-NP-Za-km-z]{24}\z/)
    end

    it "differs between groups" do
      expect(create(:group).invite_token).not_to eq(create(:group).invite_token)
    end
  end

  describe "#open_to_new_members?" do
    let(:group) { create(:group, users: create_list(:user, 2)) }

    context "when names haven't been drawn" do
      it "is true" do
        expect(group).to be_open_to_new_members
      end
    end

    context "when names have been drawn" do
      it "is false" do
        create(:pair, group:, user: group.users.first, other: group.users.last)

        expect(group).not_to be_open_to_new_members
      end
    end
  end

  describe "#reset_draw" do
    it "removes this group's pairings only, keeping ideas" do
      owner, member, other = create_list(:user, 3)
      group = create(:group, owner:, users: [owner, member, other])
      group.assign_partners
      idea = create(:idea, group:, user: member)

      group.reset_draw

      expect(group.pairs).to be_empty
      expect(group.ideas).to eq([idea])
      expect(group).to be_open_to_new_members
    end
  end

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
