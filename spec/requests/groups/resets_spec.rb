require "rails_helper"

RSpec.describe "POST /groups/:group_id/reset" do
  context "when the authenticated user is the owner" do
    it "clears the pairings and ideas and redirects to the dashboard" do
      owner, member, other = create_list(:user, 3)
      group = create(:group, owner:, users: [owner, member, other])
      group.assign_partners
      create(:idea, group:, user: member)

      authenticate(owner)
      post group_reset_path(group)

      expect(group.pairs.count).to eq(0)
      expect(group.ideas.count).to eq(0)
      expect(group.users.count).to eq(3)
      expect(response).to redirect_to(dashboard_path)
      expect(flash[:success]).to include("reset for this year")
    end
  end

  context "when the authenticated user is a non-owner member" do
    it "clears nothing" do
      owner, member, other = create_list(:user, 3)
      group = create(:group, owner:, users: [owner, member, other])
      group.assign_partners

      authenticate(member)
      post group_reset_path(group)

      expect(group.pairs.count).to eq(3)
      expect(flash[:error]).to be_present
    end
  end

  context "when there is no authenticated user" do
    it "redirects to the sign in flow" do
      group = create(:group)

      post group_reset_path(group)

      expect(response).to redirect_to(root_path)
    end
  end
end
