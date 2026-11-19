class EmailConfirmationsController < ApplicationController
  layout "getting_started", only: :show

  before_action :require_valid_token, only: %i[show create]
  before_action :require_logged_in, only: %i[destroy resend]

  # Over the limit, the link just isn't sent again; the earlier ones still work
  rate_limit to: 5, within: 15.minutes, only: :resend, by: -> { Current.user&.id }, with: -> { redirect_to edit_user_path(Current.user) }

  # Only confirms; the change is applied on POST so link scanners/prefetchers can't burn the token
  def show
    render locals: {
      token:
    }
  end

  def create
    new_email = user.unconfirmed_email

    if user.confirm_email_change
      render_message(
        icon: :check,
        title: "Email updated",
        subtitle: "From now on you'll sign in with #{new_email}."
      )
    else
      render_message(
        icon: :exclamation_triangle,
        title: "Email not changed",
        subtitle: "#{new_email} is now used by another account, so you'll keep signing in with #{user.email}.",
        status: :unprocessable_content
      )
    end
  end

  def destroy
    Current.user.cancel_email_change

    redirect_to edit_user_path(Current.user)
  end

  def resend
    UserMailer.confirm_email_change(Current.user).deliver_later if Current.user.unconfirmed_email.present?

    redirect_to edit_user_path(Current.user)
  end

  private

  def require_valid_token
    return if user

    render_message(
      icon: :envelope,
      title: "That link has expired",
      subtitle: "Confirmation links work for an hour, and only for the most recent change. Ask for the change again from your account.",
      status: :unprocessable_content
    )
  end

  def render_message(icon:, title:, subtitle:, status: :ok)
    render "shared/message", layout: "getting_started", status:, locals: {
      icon: icon,
      title: title,
      subtitle: subtitle,
      link_text: logged_in? ? "Go to your account" : "Sign in",
      link_url: logged_in? ? edit_user_path(Current.user) : new_session_path
    }
  end

  def user
    return @_user if defined?(@_user)

    @_user = User.find_by_token_for(:email_change, token)
  end

  def token
    params[:token].to_s
  end
end
