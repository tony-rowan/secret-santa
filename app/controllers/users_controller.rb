class UsersController < ApplicationController
  before_action :require_logged_in, except: %i[new create]
  before_action :require_owner, except: %i[show new create]

  def show
    @user = user
  end

  def new
    @user = User.new
  end

  def edit
    @user = user
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
    @user = user

    if @user.update(user_params)
      redirect_to root_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    user.destroy
    redirect_to root_path, notice: 'User was successfully destroyed.'
  end

  private

  def user_params
    params.require(:user).permit(:name, :login, :password)
  end

  def require_owner
    redirect_to root_path if Current.user != user
  end

  def user
    @user ||= User.find(params[:id])
  end
end
