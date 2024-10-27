require "rails_helper"

RSpec.describe RemoveGroupMembership do
  describe "#perform" do
    it "correctly sets the success message when the actor is the owner" do
      group, owner, member = setup_group
      actor = owner

      action = described_class.new(group:, member:, actor:).tap(&:perform)

      expect(action.messages[:success]).to include("Removed #{member.name} from the group!")
    end

    it "correctly sets the success message when the actor is the member" do
      group, _owner, member = setup_group
      actor = member

      action = described_class.new(group:, member:, actor:).tap(&:perform)

      expect(action.messages[:success]).to include("Left group #{group.name}!")
    end

    it "correctly sets the sucess message when there is no actor" do
      group, _owner, member = setup_group
      actor = nil

      action = described_class.new(group:, member:, actor:).tap(&:perform)

      expect(action.messages[:success]).to include("Removed #{member.name} from the group!")
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

      it "has an informative message if the actor is the owner" do
        group, owner, member = setup_group
        actor = owner
        group.pairs = [
          create(:pair, group: group, user: owner, other: member),
          create(:pair, group: group, user: member, other: owner)
        ]

        action = described_class.new(group:, member:, actor:).tap(&:perform)

        expect(action.messages[:notice]).to include("Secret santa partners have been un-assigned")
      end

      it "does not include the message if the actor is the member" do
        group, owner, member = setup_group
        actor = member
        group.pairs = [
          create(:pair, group: group, user: owner, other: member),
          create(:pair, group: group, user: member, other: owner)
        ]

        action = described_class.new(group:, member:, actor:).tap(&:perform)

        expect(action.messages[:notice]).not_to include("Secret santa partners have been un-assigned")
      end

      it "has an informative message if the actor not set" do
        group, owner, member = setup_group
        actor = nil
        group.pairs = [
          create(:pair, group: group, user: owner, other: member),
          create(:pair, group: group, user: member, other: owner)
        ]

        action = described_class.new(group:, member:, actor:).tap(&:perform)

        expect(action.messages[:notice]).to include("Secret santa partners have been un-assigned")
      end
    end

    context "when there are no secret santa pairings" do
      it "does not include a message to the contrary" do
        group, owner, member = setup_group
        actor = owner

        action = described_class.new(group:, member:, actor:).tap(&:perform)

        expect(action.messages[:notice]).not_to include("Secret santa partners have been un-assigned")
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
