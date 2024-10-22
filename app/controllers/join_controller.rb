class JoinController < ApplicationController
  before_action :require_logged_in

  def new
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

  def join_code
    return @_join_code if defined?(@_join_code)

    # Allow join_code from params to override the one from the session, but always clean up the
    # join code from the session
    join_code_from_session = session.delete(:join_code)
    join_code_from_params = params[:join_code].presence

    @_join_code = join_code_from_params || join_code_from_session
  end

  def join_group_params
    params.require(:join_group).permit(:join_code).merge(user: Current.user)
  end

  def require_logged_in
    return if logged_in?

    # Save the join code into the session to allow it to follow the user through the
    # sign in or sign up flow
    session[:join_code] = params[:join_code].presence
    redirect_to(root_path)
  end
end
