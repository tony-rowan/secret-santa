module MagicLinkHelper
  def last_magic_link_url
    last_email_link_url("/session/magic_link")
  end

  def last_email_confirmation_url
    last_email_link_url("/email_confirmation")
  end

  def last_email_link_url(path)
    mail = ActionMailer::Base.deliveries.last
    mail.text_part.body.decoded[%r{https?://\S+#{Regexp.escape(path)}\?\S+}]
  end
end

module SigninHelper
  def sign_in(user)
    visit(new_session_path)
    request_magic_link(user.email)
    follow_magic_link
  end

  def request_magic_link(email)
    fill_in("Your email", with: email)
    click_on("Email me a sign-in link")

    expect(page).to have_text("Check your email")
  end

  # Visit the emailed link by path (the host in the email isn't the Capybara server). The page
  # signs the user in by itself with JS.
  def follow_magic_link
    visit(URI(last_magic_link_url).request_uri)
  end

  # Confirms the styled dialog that stands in for confirm()
  def confirm_dialog(button)
    within("dialog[open]") { click_on(button) }
  end
end

RSpec.configure do |config|
  config.include(MagicLinkHelper, type: :feature)
  config.include(MagicLinkHelper, type: :request)
  config.include(MagicLinkHelper, type: :mailer)
  config.include(SigninHelper, type: :feature)
end
