require "rails_helper"

RSpec.describe JoinGroup do
  describe "#save" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    context "with a group's invite token" do
      it "adds the user to the group" do
        result = JoinGroup.new(user:, invite_token: group.invite_token).save

        expect(result).to eq(true)
        expect(user.reload.groups).to eq([group])
      end
    end

    context "when the user is already a member" do
      it "doesn't add them twice, but still succeeds" do
        user.groups << group

        result = JoinGroup.new(user:, invite_token: group.invite_token).save

        expect(result).to eq(true)
        expect(user.reload.groups).to eq([group])
      end
    end

    context "when names have been drawn" do
      before { create(:pair, group:, user: group.owner, other: create(:user)) }

      it "doesn't add the user" do
        form = JoinGroup.new(user:, invite_token: group.invite_token)

        expect(form.save).to eq(false)
        expect(form).to be_closed
        expect(user.reload.groups).to be_empty
      end

      context "when the user is already a member" do
        it "succeeds" do
          user.groups << group

          form = JoinGroup.new(user:, invite_token: group.invite_token)

          expect(form.save).to eq(true)
          expect(form).not_to be_closed
        end
      end
    end

    context "with a token that matches no group" do
      it "fails without being closed" do
        form = JoinGroup.new(user:, invite_token: "nope")

        expect(form.save).to eq(false)
        expect(form).not_to be_closed
        expect(form.group).to be_nil
      end
    end

    context "without a token" do
      it "fails" do
        expect(JoinGroup.new(user:, invite_token: "").save).to eq(false)
      end
    end
  end
end
