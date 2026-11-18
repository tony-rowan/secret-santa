class UserMailerPreview < ActionMailer::Preview
  def confirm_email_change
    user = User.first || User.new(name: "Trevor Slattery", email: "trevor@example.com")
    user.unconfirmed_email = "trevor.new@example.com"

    UserMailer.confirm_email_change(user)
  end
end
