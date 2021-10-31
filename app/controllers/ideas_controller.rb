class IdeasController < ApplicationController
  before_action :require_logged_in

  def create
    @idea = Idea.new(idea_params)

    if @idea.save
      redirect_to root_path
    else
      render "dashboards/show"
    end
  end

  private

  def idea_params
    params.require(:idea).permit(:idea).merge(user: Current.user, group: Current.group)
  end
end
