module MagicLinkHelper
  def last_magic_link_url
    mail = ActionMailer::Base.deliveries.last
    mail.text_part.body.decoded[%r{https?://\S+/session/magic_link\?\S+}]
  end
end

module SigninHelper
  def sign_in(user)
    visit(root_path)
    click_on("Sign In")
    fill_in("Email", with: user.email)
    click_on("Email me a sign-in link")

    expect(page).to have_text("Check your email")

    follow_magic_link
  end

  # Visit the emailed link by path (the host in the email isn't the Capybara server). The page
  # signs the user in by itself with JS.
  def follow_magic_link
    visit(URI(last_magic_link_url).request_uri)
  end
end

RSpec.configure do |config|
  config.include(MagicLinkHelper, type: :feature)
  config.include(MagicLinkHelper, type: :request)
  config.include(MagicLinkHelper, type: :mailer)
  config.include(SigninHelper, type: :feature)
end
