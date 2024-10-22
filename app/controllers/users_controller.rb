class UsersController < ApplicationController
  layout "authentication", only: %i[new create]

  before_action :require_logged_in, except: %i[new create]
  before_action :require_owner, except: %i[show new create]

  def show
    @user = user
  end

  def new
    user = User.new

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

    if user.save
      authenticate_user(user)

      if group
        redirect_to(join_with_code_path(join_code), success: "Account Created")
      else
        redirect_to(dashboard_path, success: "Account Created. Now add some ideas for your partner")
      end
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
    params.require(:user).permit(:name, :login, :password)
  end

  def require_owner
    redirect_to root_path if Current.user != user
  end

  def user
    @user ||= User.find(params[:id])
  end

  def group
    return @_group if defined?(@_group)

    @_group = Group.find_by(join_code:) if join_code
  end

  def join_code
    session[:join_code].presence
  end
end
