class SessionsController < ApplicationController
  layout "authentication"

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
