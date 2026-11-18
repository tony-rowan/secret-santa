class SessionMailerPreview < ActionMailer::Preview
  def sign_in_link
    SessionMailer.sign_in_link(User.first || User.new(name: "Trevor Slattery", email: "trevor@example.com"))
  end

  def sign_in_link_with_join_code
    SessionMailer.sign_in_link(User.first || User.new(name: "Trevor Slattery", email: "trevor@example.com"), join_code: "ABCDEF")
  end
end
