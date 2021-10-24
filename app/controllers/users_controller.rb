class UsersController < ApplicationController
  before_action :require_logged_in, except: :update
  before_action :require_logged_in_or_invite_token, only: :update

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      authenticate_user(@user)
      redirect_to root_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      authenticate_user(@user)
      redirect_to root_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def user_params
    params.require(:user).permit(:name, :password).merge(invite_token: nil)
  end

  def require_logged_in_or_invite_token
    user = Current.user || User.find_by(params.require(:user).permit(:invite_token))
    redirect_to(new_sessions_path) unless user
  end
end
