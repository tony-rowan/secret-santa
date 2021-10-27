class InvitesController < ApplicationController
  before_action :redirect_memebers

  def show
    @group = group
  end

  private

  def redirect_memebers
    redirect_to group if Current.user.in?(group.users)
  end

  def group
    @group ||= Group.find_by!(invite_token: params[:id])
  end
end
