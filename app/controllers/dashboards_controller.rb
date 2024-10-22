class DashboardsController < ApplicationController
  before_action :require_logged_in

  def show
    render locals: {
      pair: pair_for_current_group,
      idea: Idea.new
    }
  end

  private

  def pair_for_current_group
    return nil unless Current.group

    Current.user.pairs.find_by(group: Current.group)
  end
end
