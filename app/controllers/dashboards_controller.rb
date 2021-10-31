class DashboardsController < ApplicationController
  before_action :require_logged_in
  before_action :require_group

  def show
    @pair = Current.user.pairs.find_by(group: Current.group)
    @idea = Idea.new
  end

  private

  def require_group
    redirect_to new_group_path if Current.group.nil?
  end
end
