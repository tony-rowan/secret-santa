class UsersController < ApplicationController
  before_action :require_logged_in
  before_action :require_owner, except: :show

  # Only submits that actually request an email change count, since each one sends an email
  rate_limit to: 5, within: 15.minutes, only: :update, name: "email_change", by: -> { Current.user&.id }, if: -> { email_change_requested? }, with: -> { redirect_to edit_user_path(user), error: RATE_LIMIT_MESSAGE }

  def show
    @user = user
  end

  def edit
    render locals: {
      user: user,
      new_email: nil
    }
  end

  def update
    update_account = UpdateAccount.new(user:, name: user_params[:name], email: user_params[:email])

    if update_account.perform
      redirect_to edit_user_path(user),
        success: update_account.messages[:success],
        notice: update_account.messages[:notice]
    else
      render :edit, status: :unprocessable_content, locals: {
        user: user,
        new_email: user_params[:email]
      }
    end
  end

  def destroy
    DeleteAccount.new(user:).perform
    cookies.delete(:user_id)
    reset_session

    redirect_to root_path, notice: "Your account has been deleted"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def email_change_requested?
    UpdateAccount.new(user:, email: user_params[:email]).email_changing?
  end

  def require_owner
    redirect_to root_path if Current.user != user
  end

  def user
    @user ||= User.find(params[:id])
  end
end
