class SessionMailerPreview < ActionMailer::Preview
  def sign_in_link
    SessionMailer.sign_in_link(User.first || User.new(name: "Trevor Slattery", email: "trevor@example.com"))
  end

  def sign_in_link_with_invite
    SessionMailer.sign_in_link(User.first || User.new(name: "Trevor Slattery", email: "trevor@example.com"), invite_token: Group.first&.invite_token || "8fKq2Xw7NhRb3TzLmA9cPdVe")
  end
end
