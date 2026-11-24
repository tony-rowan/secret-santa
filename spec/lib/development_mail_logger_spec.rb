require "rails_helper"

RSpec.describe DevelopmentMailLogger do
  describe ".delivered_email" do
    let(:url) { "http://localhost:3000/session/magic_link?token=#{"abc123" * 30}&invite_token=XYZ" }
    let(:output) { StringIO.new }
    let(:message) do
      link = url
      Mail.new do
        to "dev@example.com"
        subject "Your sign-in link"
        text_part do
          content_type "text/plain; charset=UTF-8"
          content_transfer_encoding "quoted-printable"
          body ["Sign in:\n\n#{link}\n"].pack("M")
        end
      end
    end

    around do |example|
      original = Rails.logger
      Rails.logger = ActiveSupport::Logger.new(output)
      example.run
    ensure
      Rails.logger = original
    end

    it "logs the recipient and subject" do
      described_class.delivered_email(message)

      expect(output.string).to include("To: dev@example.com", "Subject: Your sign-in link")
    end

    it "logs the decoded URL unbroken on one line" do
      described_class.delivered_email(message)

      expect(output.string.lines.map(&:chomp)).to include(url)
    end

    context "when the message has no text part" do
      let(:message) do
        Mail.new(to: "dev@example.com", subject: "Plain", body: "Just a body")
      end

      it "falls back to the decoded body" do
        described_class.delivered_email(message)

        expect(output.string).to include("Just a body")
      end
    end
  end
end
