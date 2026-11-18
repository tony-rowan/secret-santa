class MagicLinksController < ApplicationController
  layout "authentication"

  before_action :require_valid_token

  # Only confirms; signing in happens on POST so link scanners/prefetchers can't burn the token
  def show
    render locals: {
      user:,
      token:,
      join_code:
    }
  end

  def create
    user.record_sign_in
    authenticate_user(user)

    if join_code
      redirect_to(join_with_code_path(join_code), success: "Signed In")
    else
      redirect_to(dashboard_path, success: "Signed In")
    end
  end

  private

  def require_valid_token
    return if user

    redirect_to(new_session_path, error: "That sign-in link has expired or already been used, request a new one")
  end

  def user
    return @_user if defined?(@_user)

    @_user = User.find_by_token_for(:sign_in, token)
  end

  def token
    params[:token].to_s
  end

  def join_code
    params[:join_code].presence || session[:join_code].presence
  end
end
