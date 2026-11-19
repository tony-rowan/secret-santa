# The first step after a new account's first sign-in: choosing how they appear to their group
class DisplayNamesController < ApplicationController
  layout "getting_started"

  before_action :require_nameless_user

  def new
    render locals: {
      user: Current.user
    }
  end

  def create
    user = Current.user
    user.name = params.dig(:user, :name).to_s

    if user.save
      # The join page picks up an invite's code from the session, or asks for one
      redirect_to join_path
    else
      render :new, status: :unprocessable_content, locals: {
        user:
      }
    end
  end

  private

  def require_nameless_user
    if logged_out?
      redirect_to(root_path)
    elsif Current.user.name.present?
      redirect_to(dashboard_path)
    end
  end
end
