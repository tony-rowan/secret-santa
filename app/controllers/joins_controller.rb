class JoinsController < ApplicationController
  before_action :require_logged_in

  def show
    form = JoinGroup.new

    render locals: {
      form:
    }
  end

  def create
    form = JoinGroup.new(**join_group_params)

    if form.save
      Current.group = form.group

      redirect_to(dashboard_path, success: "Group Joined. Now add some ideas to help your partner.")
    else
      render :show, status: :unprocessable_entity, locals: {
        form:
      }
    end
  end

  private

  def join_group_params
    params.require(:join_group).permit(:join_code).merge(user: Current.user)
  end
end
