class SessionMailer < ApplicationMailer
  def sign_in_link(user, join_code: nil)
    @user = user
    @magic_link_url = session_magic_link_url(token: user.generate_token_for(:sign_in), join_code: join_code)

    mail(to: user.email, subject: "Your Secret Santa sign-in link")
  end
end
