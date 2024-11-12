require "rails_helper"

RSpec.describe JoinGroup do
  describe "#save" do
    context "with a join code for a valid group" do
      it "adds the user to the group" do
        user = FactoryBot.create(:user)
        group = FactoryBot.create(:group)
        join_code = group.join_code

        result = JoinGroup.new(user:, join_code:).save

        expect(result).to eq(true)
        expect(user.reload.groups).to eq([group])
        expect(group.reload.users).to include(user)
      end
    end

    context "with a join code for a group of which the user is already a member" do
      it "does not double the user to the group, but still returns true" do
        user = FactoryBot.create(:user)
        group = FactoryBot.create(:group)
        join_code = group.join_code
        user.groups << group

        result = JoinGroup.new(user:, join_code:).save

        expect(result).to eq(true)
        expect(user.reload.groups).to eq([group])
        expect(group.reload.users).to include(user)
      end
    end
  end
end
