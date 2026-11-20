require "rails_helper"

RSpec.describe Group do
  describe "#join_code" do
    it "is 8 characters with no look-alikes (no I, L, O or U)" do
      expect(create(:group).join_code).to match(/\A[0-9A-HJKMNP-TV-Z]{8}\z/)
    end

    it "skips codes that are already taken" do
      create(:group, join_code: "AAAAAAAA")
      allow(SecureRandom).to receive(:alphanumeric).and_return("AAAAAAAA", "BBBBBBBB")

      expect(create(:group).join_code).to eq("BBBBBBBB")
    end

    context "when the group was made with an older 12-character code" do
      it "keeps it" do
        expect(create(:group, join_code: "ABCDEF123456").join_code).to eq("ABCDEF123456")
      end
    end

    it "is found however it's typed" do
      group = create(:group, join_code: "AB01C0D1E1F2")

      expect(Group.find_by(join_code: "ab01-c0d1-e1f2")).to eq(group)
      expect(Group.find_by(join_code: " AB01 C0D1 E1F2 ")).to eq(group)
      expect(Group.find_by(join_code: "ABOI-COD1-ELF2")).to eq(group)
    end
  end

  describe "#formatted_join_code" do
    it "splits the code into groups of four" do
      expect(build(:group, join_code: "ABCDEF12").formatted_join_code).to eq("ABCD-EF12")
      expect(build(:group, join_code: "ABCDEF123456").formatted_join_code).to eq("ABCD-EF12-3456")
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
