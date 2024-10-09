class SessionsController < ApplicationController
  layout "authentication"

  def create
    if (user = User.find_by(login: login)&.authenticate(password))
      authenticate_user(user)
      redirect_to(dashboard_path)
    else
      flash.now[:error] = "Unknown email/password combination"
      render(:new, status: :unprocessable_entity)
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to(root_path)
  end

  private

  def login
    params[:login]
  end

  def password
    params[:password]
  end
end
