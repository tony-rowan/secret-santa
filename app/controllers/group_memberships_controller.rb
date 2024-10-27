class GroupMembershipsController < ApplicationController
  before_action :require_authenticated_user
  before_action :require_authorisation
  before_action :require_member

  def destroy
    message = build_message
    group.kick(member)
    redirect_to dashboard_path, success: message
  end

  private

  def build_message
    will_remove_pairs = group.pairs.any?
    is_owner = group.owner?(Current.user)

    [
      is_owner ? "Kicked #{member.name} out of the group!" : "Left group #{group.name}!",
      will_remove_pairs ? "Partners have been unassigned." : nil
    ].compact.join(" ")
  end

  def require_authenticated_user
    return if Current.user

    redirect_to root_path, error: "You must be signed in to do that"
  end

  def require_authorisation
    return if group.owner?(Current.user)
    return if Current.user == member

    redirect_to dashboard_path, error: "You're not allowed to do that"
  end

  def require_member
    return if group.member?(member)

    redirect_to dashboard_path, error: "That user is not part of the group"
  end

  def group
    @_group ||= Group.find(params[:group_id])
  end

  def member
    @_member ||= User.find(params[:user_id])
  end
end
