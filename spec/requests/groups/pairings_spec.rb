require "rails_helper"

RSpec.describe "DELETE /groups/:group_id/pairings" do
  context "when the authenticated user is the owner of the group" do
    it "removes everything for that group only" do
      group, owner, member = setup_group
      other_group = create(:group, owner:, users: [owner, member])
      create_for(group, owner, member)
      other_record = create(:pair, group: other_group, user: owner, other: member)

      authenticate(owner)
      delete group_pairings_path(group)

      expect(group.reload.pairs).to be_empty
      expect(other_group.reload.pairs).to eq([other_record])
    end

    it "redirects to the manage group page with a success message" do
      group, owner, _member = setup_group

      authenticate(owner)
      delete group_pairings_path(group)

      expect(response).to redirect_to(edit_group_path(group))
      expect(flash[:success]).to eq("Secret santa pairings removed")
    end
  end

  context "when the authenticated user is a non-owner member" do
    it "does not remove anything" do
      group, owner, member = setup_group
      create_for(group, owner, member)

      authenticate(member)
      delete group_pairings_path(group)

      expect(group.reload.pairs.count).to eq(2)
    end

    it "redirects to the dashboard with an error" do
      group, _owner, member = setup_group

      authenticate(member)
      delete group_pairings_path(group)

      expect(response).to redirect_to(dashboard_path)
      expect(flash[:error]).to be_present
    end
  end

  context "when there is no authenticated user" do
    it "does not remove anything" do
      group, owner, member = setup_group
      create_for(group, owner, member)

      delete group_pairings_path(group)

      expect(group.reload.pairs.count).to eq(2)
    end

    it "redirects to the sign in flow" do
      group, _owner, _member = setup_group

      delete group_pairings_path(group)

      expect(response).to redirect_to(root_path)
    end
  end

  private

  def setup_group
    owner, member = create_list(:user, 2)

    [create(:group, owner:, users: [owner, member]), owner, member]
  end

  def create_for(group, owner, member)
    create(:pair, group:, user: owner, other: member)
    create(:pair, group:, user: member, other: owner)
  end
end
