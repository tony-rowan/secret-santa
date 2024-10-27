class GroupMembershipsController < ApplicationController
  before_action :require_authenticated_user
  before_action :require_authorisation

  def destroy
    remove_group_membership_action = RemoveGroupMembership.new(group: group, member: member, actor: Current.user)

    if remove_group_membership_action.perform
      redirect_to dashboard_path,
        success: remove_group_membership_action.messages[:success],
        notice: remove_group_membership_action.messages[:notice]
    else
      redirect_to dashboard_path,
        error: remove_group_membership_action.errors[:base]
    end
  end

  private

  def require_authenticated_user
    return if Current.user

    redirect_to root_path, error: "You must be signed in to do that"
  end

  def require_authorisation
    return if group.owner?(Current.user)
    return if Current.user == member

    redirect_to dashboard_path, error: "You're not allowed to do that"
  end

  def group
    @_group ||= Group.find(params[:group_id])
  end

  def member
    @_member ||= User.find(params[:user_id])
  end
end
