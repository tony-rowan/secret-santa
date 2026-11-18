class SessionsController < ApplicationController
  layout "authentication"

  rate_limit to: 10, within: 3.minutes, only: :create, name: "ip", with: -> { redirect_to new_session_path, error: RATE_LIMIT_MESSAGE }
  rate_limit to: 3, within: 15.minutes, only: :create, name: "email", by: -> { params[:email].to_s.strip.downcase }, with: -> { redirect_to new_session_path, error: RATE_LIMIT_MESSAGE }

  def new
    render locals: {
      group:
    }
  end

  def create
    # Respond identically whether or not the account exists, so the response doesn't reveal it
    if (user = User.find_by(email:))
      send_sign_in_link(user)
    end

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
    params[:email]
  end

  def group
    return @_group if defined?(@_group)

    @_group = Group.find_by(join_code:) if join_code
  end

  def join_code
    session[:join_code].presence
  end
end
