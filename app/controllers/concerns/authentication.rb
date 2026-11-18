module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate

    helper_method :logged_in?, :logged_out?
  end

  def require_logged_in
    redirect_to(root_path) unless logged_in?
  end

  def logged_in?
    Current.user
  end

  def logged_out?
    !logged_in?
  end

  private

  def authenticate
    return unless authenticated_user

    Current.user = authenticated_user
  end

  def authenticated_user
    @authenticated_user ||= User.find_by(id: cookies.encrypted[:user_id])
  end

  def authenticate_user(user)
    cookies.encrypted[:user_id] = user.id
  end

  # The join code is baked into the link because it may be opened in another browser
  def send_sign_in_link(user)
    SessionMailer.sign_in_link(user, join_code: session[:join_code].presence).deliver_later
  end
end
