class InvitesController < ApplicationController
  before_action :require_logged_out

  def show
    @user = User.find_by!(invite_token: params[:id])
  end
end
