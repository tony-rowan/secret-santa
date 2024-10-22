class UsersController < ApplicationController
  layout "authentication", only: %i[new create]

  before_action :require_logged_in, except: %i[new create]
  before_action :require_owner, except: %i[show new create]

  def show
    @user = user
  end

  def new
    user = User.new
    group = invited_group(params)

    render locals: {
      user:,
      group:
    }
  end

  def edit
    @user = user
  end

  def create
    user = User.new(user_params)
    group = invited_group(user_params)

    message = if group
      "Account Created. Add some ideas for your secret santa partner"
    else
      "Account Created. Now either join a group or make your own"
    end

    if user.save
      authenticate_user(user)
      redirect_to(dashboard_path, success: message)
    else
      render :new, status: :unprocessable_entity, locals: {
        user:,
        group:
      }
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
      :name, :login, :password, :invite_token
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
end
