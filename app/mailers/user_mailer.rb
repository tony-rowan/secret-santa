class UserMailer < ApplicationMailer
  def confirm_email_change(user)
    @user = user
    @new_email = user.unconfirmed_email
    @confirmation_url = email_confirmation_url(token: user.generate_token_for(:email_change))

    mail(to: @new_email, subject: "Confirm your new Secret Santa email")
  end
end
