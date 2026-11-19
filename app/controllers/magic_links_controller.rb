class MagicLinksController < ApplicationController
  layout "getting_started"

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
    return redirect_to_new_link unless save_new_account

    user.record_sign_in
    authenticate_user(user)

    if user.name.nil?
      # Picked back up by the join page once they've chosen a name
      session[:join_code] = join_code if join_code
      redirect_to(new_display_name_path)
    elsif join_code
      redirect_to(join_with_code_path(join_code), success: "Signed In")
    else
      redirect_to(dashboard_path, success: "Signed In")
    end
  end

  private

  def require_valid_token
    redirect_to_new_link unless user
  end

  def redirect_to_new_link
    redirect_to(new_session_path, error: "That sign-in link has expired or already been used, request a new one")
  end

  # A sign-up link creates the account the first time it's followed
  def save_new_account
    return true if user.persisted?

    user.save
  rescue ActiveRecord::RecordNotUnique
    false
  end

  def user
    return @_user if defined?(@_user)

    @_user = User.find_by_token_for(:sign_in, token) || User.build_from_sign_up_token(token)
  end

  def token
    params[:token].to_s
  end

  def join_code
    params[:join_code].presence || session[:join_code].presence
  end
end
