require "rails_helper"

RSpec.describe UpdateAccount do
  describe "#perform" do
    context "when only the name changes" do
      it "saves the name and sends no email" do
        user = create(:user, name: "Old", email: "old@example.com")

        action = described_class.new(user:, name: "New", email: "old@example.com")

        expect(action.perform).to be(true)
        expect(user.reload).to have_attributes(name: "New", unconfirmed_email: nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when the email changes" do
      it "holds the normalised address pending and sends one email to it" do
        user = create(:user, email: "old@example.com")

        action = described_class.new(user:, name: user.name, email: " New@Example.com ")

        expect(action.perform).to be(true)
        expect(user.reload).to have_attributes(email: "old@example.com", unconfirmed_email: "new@example.com")
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["new@example.com"])
      end

      it "still saves a name change from the same submit" do
        user = create(:user, name: "Old")

        action = described_class.new(user:, name: "New", email: "new@example.com")
        action.perform

        expect(user.reload.name).to eq("New")
      end

      it "invalidates links for the previously pending address" do
        user = create(:user)
        described_class.new(user:, name: user.name, email: "first@example.com").perform
        token = user.generate_token_for(:email_change)

        described_class.new(user:, name: user.name, email: "second@example.com").perform

        expect(User.find_by_token_for(:email_change, token)).to be_nil
      end
    end

    context "when the email is the same as now" do
      it "changes nothing and sends no email" do
        user = create(:user, email: "old@example.com")

        action = described_class.new(user:, name: user.name, email: "OLD@example.com")

        expect(action.perform).to be(true)
        expect(user.reload.unconfirmed_email).to be_nil
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when the email is blank" do
      it "changes nothing and sends no email" do
        user = create(:user)

        action = described_class.new(user:, name: user.name, email: "")

        expect(action.perform).to be(true)
        expect(user.reload.unconfirmed_email).to be_nil
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when the address is taken by another user" do
      it "fails with an error on email and sends nothing" do
        user = create(:user)
        other = create(:user)

        action = described_class.new(user:, name: user.name, email: other.email)

        expect(action.perform).to be(false)
        expect(user.errors[:email]).to eq(["has already been taken"])
        expect(user.reload.unconfirmed_email).to be_nil
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when the address is malformed" do
      it "fails with an error on email" do
        user = create(:user)

        action = described_class.new(user:, name: user.name, email: "nope")

        expect(action.perform).to be(false)
        expect(user.errors[:email]).to be_present
      end
    end
  end
end
