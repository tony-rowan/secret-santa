require "rails_helper"

RSpec.describe "Legal pages" do
  around do |example|
    original = Rails.configuration.x.contact_email
    Rails.configuration.x.contact_email = "hello@secret-santa.test"
    example.run
  ensure
    Rails.configuration.x.contact_email = original
  end

  describe "GET /privacy" do
    it "shows the privacy policy with a way to get in touch" do
      get privacy_path

      page = Capybara.string(response.body)
      expect(page).to have_css("h1", text: "Privacy policy")
      expect(page).to have_link("Fly.io", href: "https://fly.io")
      expect(page).to have_link("Resend", href: "https://resend.com")
      expect(page).to have_link("hello@secret-santa.test", href: "mailto:hello@secret-santa.test")
    end
  end

  describe "GET /terms" do
    it "shows the terms with a way to get in touch" do
      get terms_path

      page = Capybara.string(response.body)
      expect(page).to have_css("h1", text: "Terms and conditions")
      expect(page).to have_link("Fly.io", href: "https://fly.io")
      expect(page).to have_link("Resend", href: "https://resend.com")
      expect(page).to have_link("hello@secret-santa.test", href: "mailto:hello@secret-santa.test")
    end
  end

  context "when signed in" do
    it "still shows the pages" do
      authenticate(create(:user))

      get privacy_path
      expect(response).to have_http_status(:ok)

      get terms_path
      expect(response).to have_http_status(:ok)
    end
  end
end
