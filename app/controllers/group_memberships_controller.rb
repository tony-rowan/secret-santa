class GroupMembershipsController < ApplicationController
  before_action :require_authenticated_user
  before_action :require_authorisation

  def destroy
    remove_group_membership_action = RemoveGroupMembership.new(group: group, member: member, actor: Current.user)

    remove_group_membership_action.perform

    redirect_back_or_to dashboard_path
  end

  private

  def require_authenticated_user
    return if Current.user

    redirect_to root_path
  end

  def require_authorisation
    return if group.owner?(Current.user)
    return if Current.user == member

    redirect_to dashboard_path
  end

  def group
    @_group ||= Group.find(params[:group_id])
  end

  def member
    @_member ||= User.find(params[:user_id])
  end
end
