class UsersController < ApplicationController
  before_action :require_logged_in, except: %i[new create]
  before_action :require_owner, except: %i[show new create]

  def show
    @user = user
  end

  def new
    @user = User.new
    @user.groups.build
    @group = invited_group(params)
  end

  def edit
    @user = user
  end

  def create
    @user = User.new(user_params)
    @group = invited_group(user_params)

    if @user.save
      authenticate_user(@user)
      redirect_to_after_create_account
    else
      render :new
    end
  end

  def update
    @user = user

    if @user.update(user_params)
      redirect_to root_path, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    user.destroy
    redirect_to root_path, notice: "User was successfully destroyed."
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :login, :password, :invite_token, groups_attributes: [:name, :rules]
    )
  end

  def require_owner
    redirect_to root_path if Current.user != user
  end

  def user
    @user ||= User.find(params[:id])
  end

  def invited_group(params)
    Group.find_by_invite_token(params[:invite_token])
  end

  def redirect_to_after_create_account
    if @group
      redirect_to root_path, notice: "Welcome to the Secret Santa group #{@group.name}"
    else
      redirect_to @user.owned_groups.last
    end
  end
end
