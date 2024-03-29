class InvitesController < ApplicationController
  before_action :redirect_members, only: :show
  before_action :require_logged_in, only: :update

  def show
    @group = group
  end

  def update
    Current.user.groups << group
    Current.group = group
    redirect_to dashboard_path
  end

  private

  def redirect_members
    redirect_to dashboard_path if Current.user.in?(group.users)
  end

  def group
    @group ||= Group.find_by_invite_token!(params[:id])
  end
end
