require "rails_helper"

RSpec.describe "DELETE /groups/:group_id/memberships/:user_id" do
  context "when the authenticated user is the owner of the group" do
    it "removes the user from the group" do
      group, owner, group_member = setup_group

      authenticate(owner)
      delete group_membership_path(group, group_member)

      expect(group.reload.users).to eq([owner])
    end

    it "redirects to the dashboard" do
      group, owner, group_member = setup_group

      authenticate(owner)
      delete group_membership_path(group, group_member)

      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when the authenticated user is the requested user" do
    it "removes the user from the group" do
      group, owner, group_member = setup_group

      authenticate(group_member)
      delete group_membership_path(group, group_member)

      expect(group.reload.users).to eq([owner])
    end

    it "redirects to the dashboard" do
      group, _owner, group_member = setup_group

      authenticate(group_member)
      delete group_membership_path(group, group_member)

      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when the authenticated user is not the user or the owner" do
    it "does not remove the user" do
      group, owner, group_member = setup_group
      authenticated_user = create(:user)

      authenticate(authenticated_user)
      delete group_membership_path(group, group_member)

      expect(group.reload.users).to eq([owner, group_member])
    end

    it "redirects to the dashboard" do
      group, _owner, group_member = setup_group
      authenticated_user = create(:user)

      authenticate(authenticated_user)
      delete group_membership_path(group, group_member)

      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when there is no authenticated user" do
    it "does not remove the user" do
      group, owner, group_member = setup_group

      delete group_membership_path(group, owner)

      expect(group.reload.users).to eq([owner, group_member])
    end

    it "redirects to the sign in flow" do
      group, owner, _group_member = setup_group

      delete group_membership_path(group, owner)

      expect(response).to redirect_to(root_path)
    end
  end

  context "when the user isn't part of the group" do
    it "doesn't change any members" do
      group, owner, group_member = setup_group
      other_user = create(:user)

      authenticate(owner)
      delete group_membership_path(group, other_user)

      expect(group.reload.users).to eq([owner, group_member])
    end

    it "redirects to the dashboard" do
      group, owner, _group_member = setup_group
      other_user = create(:user)

      authenticate(owner)
      delete group_membership_path(group, other_user)

      expect(response).to redirect_to(dashboard_path)
    end
  end

  private

  def setup_group
    owner, group_member = create_list(:user, 2)
    users = [owner, group_member]

    [create(:group, owner:, users:), *users]
  end
end
