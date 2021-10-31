class InvitesController < ApplicationController
  before_action :redirect_members, only: :show
  before_action :require_logged_in, only: :update

  def show
    @group = group
  end

  def update
    Current.user.groups << group
    Current.group = group
    redirect_to group
  end

  private

  def redirect_members
    redirect_to group if Current.user.in?(group.users)
  end

  def group
    @group ||= Group.find_by!(invite_token: params[:id])
  end
end
