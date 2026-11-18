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
    render locals: {
      user:
    }
  end

  def create
    user = User.new(user_params)

    if user.save
      send_sign_in_link(user)

      render "sessions/check_email", locals: {
        group:
      }
    else
      render :new, status: :unprocessable_content, locals: {
        user:,
        group:
      }
    end
  end

  def update
    if user.update(user_params)
      redirect_to dashboard_path, success: "Account updated"
    else
      render :edit, status: :unprocessable_content, locals: {
        user:
      }
    end
  end

  def destroy
    user.destroy
    redirect_to root_path, notice: "User was successfully destroyed."
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
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
