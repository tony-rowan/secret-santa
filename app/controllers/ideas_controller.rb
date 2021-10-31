class IdeasController < ApplicationController
  before_action :require_logged_in
  before_action :require_owner, only: :destroy

  def create
    @idea = Idea.new(idea_params)

    if @idea.save
      redirect_to dashboard_path
    else
      render "dashboards/show"
    end
  end

  def destroy
    idea.destroy
    redirect_to dashboard_path
  end

  private

  def idea_params
    params.require(:idea).permit(:idea).merge(user: Current.user, group: Current.group)
  end

  def require_owner
    redirect_to dashboard_path unless idea.user == Current.user
  end

  def idea
    @idea ||= Idea.find(params[:id])
  end
end
