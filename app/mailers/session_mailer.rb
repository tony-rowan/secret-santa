class SessionMailer < ApplicationMailer
  def sign_in_link(user, invite_token: nil)
    @user = user
    @magic_link_url = session_magic_link_url(token: user.generate_token_for(:sign_in), invite_token: invite_token)

    mail(to: user.email, subject: "Your Secret Santa sign-in link")
  end

  # For an email with no account yet; following the link creates it
  def sign_up_link(email, invite_token: nil)
    @user = User.new(email:)
    @magic_link_url = session_magic_link_url(token: User.generate_sign_up_token(email), invite_token: invite_token)

    mail(to: email, subject: "Your Secret Santa sign-in link", template_name: "sign_in_link")
  end
end
