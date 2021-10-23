class SessionsController < ApplicationController
  skip_before_action :authenticate
  before_action :rediect_to_app_if_authenticated, only: :new

  def create
    if (user = User.find_by(name: name)&.authenticate(password))
      cookies.encrypted[:user_id] = user.id
      redirect_to(root_path)
    else
      flash[:error] = t('sessions.create.error')
      render(:new, status: :unprocessable_entity)
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to(root_path)
  end

  private

  def name
    params.require(:name)
  end

  def password
    params.require(:password)
  end
end
