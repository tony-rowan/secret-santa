class SessionsController < ApplicationController
  layout "getting_started"

  rate_limit to: 10, within: 3.minutes, only: :create, name: "ip", with: -> { render_rate_limited }
  rate_limit to: 3, within: 15.minutes, only: :create, name: "email", by: -> { params[:email].to_s.strip.downcase }, with: -> { render_rate_limited }

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
      group:,
      email:
    }
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to(root_path)
  end

  private

  def render_rate_limited
    render :new, layout: "getting_started", status: :too_many_requests, locals: {
      group: group,
      email: email,
      error: RATE_LIMIT_MESSAGE
    }
  end

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
