class SessionsController < ApplicationController
  layout "authentication"

  def new
    render locals: {
      group:
    }
  end

  def create
    if (user = User.find_by(email:)&.authenticate(password))
      authenticate_user(user)

      if group
        redirect_to(join_with_code_path(join_code), success: "Signed In")
      else
        redirect_to(dashboard_path, success: "Signed In")
      end
    else
      flash.now[:error] = "Unknown email/password combination"

      render :new, status: :unprocessable_content, locals: {
        group:
      }
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to(root_path, notice: "You're now signed out")
  end

  private

  def email
    params[:email]
  end

  def password
    params[:password]
  end

  def group
    return @_group if defined?(@_group)

    @_group = Group.find_by(join_code:) if join_code
  end

  def join_code
    session[:join_code].presence
  end
end
