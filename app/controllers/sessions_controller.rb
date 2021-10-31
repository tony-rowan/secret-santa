class SessionsController < ApplicationController
  def create
    if (user = User.find_by(login: login)&.authenticate(password))
      authenticate_user(user)
      redirect_to(root_path)
    else
      flash[:error] = "Username or password incorrect"
      render(:new, status: :unprocessable_entity)
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to(root_path)
  end

  private

  def login
    params.require(:login)
  end

  def password
    params.require(:password)
  end
end
