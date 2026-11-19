class JoinController < ApplicationController
  layout "getting_started"

  before_action :require_logged_in

  def new
    group = Group.find_by(join_code:) if join_code
    form = JoinGroup.new(join_code: group&.join_code)

    render locals: {
      group:,
      form:
    }
  end

  def create
    form = JoinGroup.new(**join_group_params)

    if form.save
      select_group(form.group)

      redirect_to(dashboard_path)
    else
      render :new, status: :unprocessable_content, locals: {
        group: nil,
        form: form
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
    params.expect(join_group: [:join_code]).merge(user: Current.user)
  end

  # Save the join code into the session to allow it to follow the user through signing in and
  # choosing a display name
  def require_logged_in
    session[:join_code] = params[:join_code] if params[:join_code].present?

    super
  end
end
