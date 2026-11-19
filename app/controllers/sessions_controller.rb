class SessionsController < ApplicationController
  layout "authentication"

  rate_limit to: 10, within: 3.minutes, only: :create, name: "ip", with: -> { redirect_to new_session_path, error: RATE_LIMIT_MESSAGE }
  rate_limit to: 3, within: 15.minutes, only: :create, name: "email", by: -> { params[:email].to_s.strip.downcase }, with: -> { redirect_to new_session_path, error: RATE_LIMIT_MESSAGE }

  before_action :redirect_logged_in_users_to_dashboard, only: :new

  def new
    render locals: {
      group: group,
      email: nil,
      error: nil
    }
  end

  # The response is the same whether or not the email has an account
  def create
    unless email.match?(URI::MailTo::EMAIL_REGEXP)
      return render :new, status: :unprocessable_content, locals: {
        group: group,
        email: email,
        error: "Please enter a valid email address"
      }
    end

    send_sign_in_link(email)

    render :check_email, locals: {
      group:
    }
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to(root_path, notice: "You're now signed out")
  end

  private

  def email
    @_email ||= User.normalize_value_for(:email, params[:email].to_s)
  end

  def redirect_logged_in_users_to_dashboard
    redirect_to dashboard_path if logged_in?
  end

  def group
    return @_group if defined?(@_group)

    @_group = Group.find_by(join_code:) if join_code
  end

  def join_code
    session[:join_code].presence
  end
end
