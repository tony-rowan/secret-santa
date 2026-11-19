module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate

    helper_method :logged_in?, :logged_out?
  end

  def require_logged_in
    if logged_out?
      redirect_to(root_path)
    elsif Current.user.name.nil?
      redirect_to(new_display_name_path)
    end
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

    # Members of several groups can switch which one the dashboard shows; without a choice it's
    # the group they joined most recently
    if (group = authenticated_user.groups.find_by(id: session[:group_id]))
      Current.group = group
    end
  end

  def select_group(group)
    session[:group_id] = group.id
    Current.group = group
  end

  def authenticated_user
    @authenticated_user ||= User.find_by(id: cookies.encrypted[:user_id])
  end

  def authenticate_user(user)
    cookies.encrypted[:user_id] = user.id
  end

  # The join code is baked into the link because it may be opened in another browser. An email with
  # no account gets a link that creates one, so signing in and signing up are the same step.
  def send_sign_in_link(email)
    join_code = session[:join_code].presence

    if (user = User.find_by(email:))
      SessionMailer.sign_in_link(user, join_code:).deliver_later
    else
      SessionMailer.sign_up_link(email, join_code:).deliver_later
    end
  end
end
