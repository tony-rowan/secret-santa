class SessionMailer < ApplicationMailer
  def sign_in_link(user, join_code: nil)
    @user = user
    @magic_link_url = session_magic_link_url(token: user.generate_token_for(:sign_in), join_code: join_code)

    mail(to: user.email, subject: "Your Secret Santa sign-in link")
  end

  # For an email with no account yet; following the link creates it
  def sign_up_link(email, join_code: nil)
    @user = User.new(email:)
    @magic_link_url = session_magic_link_url(token: User.generate_sign_up_token(email), join_code: join_code)

    mail(to: email, subject: "Your Secret Santa sign-in link", template_name: "sign_in_link")
  end
end
