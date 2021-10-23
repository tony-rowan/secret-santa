module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate

    helper_method :logged_in?, :logged_out?
  end

  def require_logged_in
    redirect_to(new_sessions_path) unless logged_in?
  end

  def logged_in?
    Current.user
  end

  def logged_out?
    !logged_in?
  end

  private

  def authenticate
    if authenticated_user
      Current.user = authenticated_user
      Current.group = authenticated_user.groups.last
    else
      redirect_to new_session_path
    end
  end

  def rediect_to_app_if_authenticated
    redirect_to root_path if authenticated_user
  end

  def authenticated_user
    @authenticated_user ||= User.find_by(id: cookies.encrypted[:user_id])
  end
end
