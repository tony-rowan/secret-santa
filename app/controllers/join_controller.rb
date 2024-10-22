class JoinController < ApplicationController
  before_action :save_join_code, only: :new
  before_action :require_logged_in

  def new
    join_code = params[:join_code].presence || session.delete(:join_code)
    group = Group.find_by(join_code:) if join_code
    form = JoinGroup.new

    render locals: {
      group:,
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

  def save_join_code
    session[:join_code] = params[:join_code].presence
  end
end
