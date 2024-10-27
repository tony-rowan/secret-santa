require "rails_helper"

RSpec.describe "DELETE /groups/:group_id/memberships/:user_id" do
  context "when the authenticated user is the owner of the group" do
    it "removes the user from the group" do
      owner, group_member = create_list(:user, 2)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      authenticate(owner)
      delete group_membership_path(group, group_member)

      expect(group.reload.users).to eq([owner])
    end

    it "redirects to the dashboard" do
      owner, group_member = create_list(:user, 2)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      authenticate(owner)
      delete group_membership_path(group, group_member)

      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when the authenticated user is the requested user" do
    it "removes the user from the group" do
      owner, group_member = create_list(:user, 2)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      authenticate(group_member)
      delete group_membership_path(group, group_member)

      expect(group.reload.users).to eq([owner])
    end

    it "redirects to the dashboard" do
      owner, group_member = create_list(:user, 2)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      authenticate(group_member)
      delete group_membership_path(group, group_member)

      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when the authenticated user is not the user or the owner" do
    it "does not remove the user" do
      owner, group_member, authenticated_user = create_list(:user, 3)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      authenticate(authenticated_user)
      delete group_membership_path(group, group_member)

      expect(group.reload.users).to eq(users)
    end

    it "redirects to the dashboard" do
      owner, group_member, authenticated_user = create_list(:user, 3)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      authenticate(authenticated_user)
      delete group_membership_path(group, group_member)

      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when there is no authenticated user" do
    it "does not remove the user" do
      owner, group_member = create_list(:user, 2)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      delete group_membership_path(group, group_member)

      expect(group.reload.users).to eq(users)
    end

    it "redirects to the sign in flow" do
      owner, group_member = create_list(:user, 2)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      delete group_membership_path(group, group_member)

      expect(response).to redirect_to(root_path)
    end
  end

  context "when the user isn't part of the group" do
    it "doesn't change any members" do
      owner, group_member, other_user = create_list(:user, 3)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      authenticate(owner)
      delete group_membership_path(group, other_user)

      expect(group.reload.users).to eq(users)
    end

    it "redirects to the dashboard" do
      owner, group_member, other_user = create_list(:user, 3)
      users = [owner, group_member]
      group = create(:group, owner:, users:)

      authenticate(owner)
      delete group_membership_path(group, other_user)

      expect(group.reload.users).to eq(users)
    end
  end
end
