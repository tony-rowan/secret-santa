require "rails_helper"

RSpec.describe SessionMailer do
  describe "#sign_in_link" do
    it "is addressed to the user with a clear subject" do
      user = create(:user, email: "trevor@example.com")

      mail = described_class.sign_in_link(user)

      expect(mail.to).to eq(["trevor@example.com"])
      expect(mail.subject).to eq("Your Secret Santa sign-in link")
    end

    it "links to the magic link page with a token that signs the user in" do
      user = create(:user)

      mail = described_class.sign_in_link(user)

      url = URI(mail.text_part.body.decoded[%r{https?://\S+}])
      params = Rack::Utils.parse_query(url.query)
      expect(url.path).to eq("/session/magic_link")
      expect(User.find_by_token_for(:sign_in, params["token"])).to eq(user)
      expect(params).not_to have_key("join_code")
      expect(mail.html_part.body.decoded).to include("/session/magic_link?token=")
    end

    it "says it comes from Secret Santa by muddle" do
      mail = described_class.sign_in_link(create(:user))

      expect(mail[:from].display_names).to eq(["Secret Santa by muddle"])
      expect(mail.text_part.body.decoded).to include("Secret Santa by muddle", "https://getmuddle.app")
      expect(Capybara.string(mail.html_part.body.decoded)).to have_link("muddle", href: "https://getmuddle.app")
    end

    it "mentions that the link expires" do
      mail = described_class.sign_in_link(create(:user))

      expect(mail.text_part.body.decoded).to include("15 minutes")
    end

    context "when a join code is given" do
      it "includes the join code in the link" do
        mail = described_class.sign_in_link(create(:user), join_code: "ABCDEF")

        expect(mail.text_part.body.decoded).to include("join_code=ABCDEF")
        expect(mail.html_part.body.decoded).to include("join_code=ABCDEF")
      end
    end
  end
end
