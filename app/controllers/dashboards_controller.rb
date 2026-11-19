class DashboardsController < ApplicationController
  before_action :require_logged_in
  before_action :select_requested_group

  def show
    render locals: {
      pair: pair_for_current_group,
      idea: Idea.new,
      idea_counts: idea_counts_for_current_group
    }
  end

  private

  # Links to a particular group (e.g. from the account page) pass its id
  def select_requested_group
    return if params[:group_id].blank?

    group = Current.user.groups.find_by(id: params[:group_id])
    select_group(group) if group
  end

  def pair_for_current_group
    return nil unless Current.group

    Current.user.pairs.find_by(group: Current.group)
  end

  # Ideas per member (user_id => count), for the organiser's member list and the draw progress
  def idea_counts_for_current_group
    return {} unless Current.group

    Current.group.ideas.group(:user_id).count
  end
end
