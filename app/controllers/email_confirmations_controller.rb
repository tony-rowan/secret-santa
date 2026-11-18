class EmailConfirmationsController < ApplicationController
  layout "authentication", only: :show

  before_action :require_valid_token, only: %i[show create]
  before_action :require_logged_in, only: :destroy

  # Only confirms; the change is applied on POST so link scanners/prefetchers can't burn the token
  def show
    render locals: {
      token:
    }
  end

  def create
    if user.confirm_email_change
      redirect_to after_confirmation_path, success: "Email updated"
    else
      redirect_to after_confirmation_path, error: "That email address is now used by another account, so your email wasn't changed"
    end
  end

  def destroy
    Current.user.cancel_email_change

    redirect_to edit_user_path(Current.user), notice: "Email change cancelled"
  end

  private

  def require_valid_token
    return if user

    redirect_to(after_confirmation_path, error: "That confirmation link has expired or is no longer valid, request the change again")
  end

  def after_confirmation_path
    logged_in? ? dashboard_path : new_session_path
  end

  def user
    return @_user if defined?(@_user)

    @_user = User.find_by_token_for(:email_change, token)
  end

  def token
    params[:token].to_s
  end
end
