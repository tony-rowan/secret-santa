require "rails_helper"

RSpec.describe UserMailer do
  describe "#confirm_email_change" do
    it "is addressed to the new address with a clear subject" do
      user = create(:user, email: "old@example.com", unconfirmed_email: "new@example.com")

      mail = described_class.confirm_email_change(user)

      expect(mail.to).to eq(["new@example.com"])
      expect(mail.subject).to eq("Confirm your new Secret Santa email")
    end

    it "links to the confirmation page with a token for the user" do
      user = create(:user, unconfirmed_email: "new@example.com")

      mail = described_class.confirm_email_change(user)

      url = URI(mail.text_part.body.decoded[%r{https?://\S+}])
      params = Rack::Utils.parse_query(url.query)
      expect(url.path).to eq("/email_confirmation")
      expect(User.find_by_token_for(:email_change, params["token"])).to eq(user)
      expect(mail.html_part.body.decoded).to include("/email_confirmation?token=")
    end

    it "mentions that the link expires" do
      user = create(:user, unconfirmed_email: "new@example.com")

      mail = described_class.confirm_email_change(user)

      expect(mail.text_part.body.decoded).to include("1 hour")
    end

    it "names the current and the new address" do
      user = create(:user, email: "old@example.com", unconfirmed_email: "new@example.com")

      mail = described_class.confirm_email_change(user)

      expect(mail.text_part.body.decoded).to include("from old@example.com to new@example.com")
      expect(Capybara.string(mail.html_part.body.decoded)).to have_text("from old@example.com to new@example.com")
    end
  end
end
