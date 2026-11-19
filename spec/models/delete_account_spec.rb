require "rails_helper"

RSpec.describe DeleteAccount do
  describe "#perform" do
    it "deletes the user and their ideas" do
      user = create(:user)
      group = create(:group, users: [user])
      create(:idea, user:, group:)

      described_class.new(user:).perform

      expect(User.exists?(user.id)).to be(false)
      expect(Idea.where(user_id: user.id)).to be_empty
    end

    context "when the user is a member of someone else's group" do
      it "removes them and clears the draw, keeping the group" do
        user = create(:user)
        group = create(:group, users: [user, create(:user)])
        create(:pair, group:, user:)

        described_class.new(user:).perform

        expect(group.reload.users).not_to include(user)
        expect(group.pairs).to be_empty
      end
    end

    context "when the user organises a group" do
      it "deletes the group for everyone" do
        user = create(:user)
        member = create(:user)
        group = create(:group, owner: user, users: [member], rule_texts: ["Under £20"])
        create(:idea, user: member, group:)

        described_class.new(user:).perform

        expect(Group.exists?(group.id)).to be(false)
        expect(User.exists?(member.id)).to be(true)
        expect(Idea.where(group_id: group.id)).to be_empty
      end
    end
  end
end
