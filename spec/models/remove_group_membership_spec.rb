require "rails_helper"

RSpec.describe RemoveGroupMembership do
  describe "#perform" do
    it "removes the member from the group" do
      group, owner, member = setup_group

      expect(described_class.new(group:, member:, actor: owner).perform).to be(true)
      expect(group.reload.users).to eq([owner])
    end

    context "when the member isn't actually a member of the group" do
      it "returns false" do
        group, owner, _member = setup_group
        actor = owner
        member = create(:user)

        action = described_class.new(group:, member:, actor:)

        expect(action.perform).to eq(false)
      end

      it "has an informative error" do
        group, owner, _member = setup_group
        actor = owner
        member = create(:user)

        action = described_class.new(group:, member:, actor:).tap(&:perform)

        expect(action.errors[:base]).to include("That user isn't a member of the group")
      end

      it "does not change group memberships" do
        group, owner, _member = setup_group
        actor = owner
        member = create(:user)

        expect { described_class.new(group:, member:, actor:).perform }.not_to change { group.reload.users.pluck(:id) }
      end
    end

    context "when there are secret santa pairings" do
      it "removes the pairings" do
        group, owner, member = setup_group
        actor = owner
        group.pairs = [
          create(:pair, group: group, user: owner, other: member),
          create(:pair, group: group, user: member, other: owner)
        ]

        described_class.new(group:, member:, actor:).perform

        expect(group.reload.pairs).to be_empty
      end
    end

    context "when the member has gift ideas" do
      it "removes their ideas in this group only" do
        owner, member = create_list(:user, 2)
        group = create(:group, owner:, users: [owner, member])
        other_group = create(:group, owner:, users: [owner, member])
        create(:idea, group:, user: member)
        owner_idea = create(:idea, group:, user: owner)
        other_idea = create(:idea, group: other_group, user: member)

        described_class.new(group:, member:, actor: owner).perform

        expect(group.ideas).to eq([owner_idea])
        expect(other_group.ideas).to eq([other_idea])
      end
    end
  end

  private

  def setup_group
    owner, group_member = create_list(:user, 2)
    users = [owner, group_member]

    [create(:group, owner:, users:), *users]
  end
end
