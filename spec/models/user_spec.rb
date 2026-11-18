require "rails_helper"

RSpec.describe User do
  describe "email" do
    context "when it has mixed case and surrounding whitespace" do
      it "is stored lowercased and stripped" do
        user = create(:user, email: "  Trevor@Example.COM \n")

        expect(user.reload.email).to eq("trevor@example.com")
      end

      it "is matched by a differently-cased lookup" do
        user = create(:user, email: "Trevor@Example.com")

        expect(User.find_by(email: " TREVOR@example.com ")).to eq(user)
      end
    end

    context "when it is not a valid email address" do
      it "is invalid with a friendly message" do
        user = build(:user, email: "not-an-email")

        expect(user).not_to be_valid
        expect(user.errors.full_messages_for(:email)).to eq(["Email Please enter a valid email address"])
      end
    end

    context "when it is blank" do
      it "is invalid with a single message" do
        user = build(:user, email: "")

        expect(user).not_to be_valid
        expect(user.errors[:email]).to eq(["Please enter your email address"])
      end
    end

    context "when it differs from another user's only by case" do
      it "is invalid as already taken" do
        create(:user, email: "trevor@example.com")
        user = build(:user, email: "TREVOR@example.com")

        expect(user).not_to be_valid
        expect(user.errors.of_kind?(:email, :taken)).to eq(true)
      end
    end
  end

  describe "email change" do
    describe "#cancel_email_change" do
      it "clears the pending address and invalidates its token" do
        user = create(:user, unconfirmed_email: "new@example.com")
        token = user.generate_token_for(:email_change)

        user.cancel_email_change

        expect(user.reload.unconfirmed_email).to be_nil
        expect(User.find_by_token_for(:email_change, token)).to be_nil
      end
    end

    describe "#confirm_email_change" do
      context "when the pending address is free" do
        it "applies it and clears the pending address" do
          user = create(:user, unconfirmed_email: "new@example.com")

          expect(user.confirm_email_change).to be(true)
          expect(user.reload).to have_attributes(email: "new@example.com", unconfirmed_email: nil)
        end
      end

      context "when the pending address was taken in the meantime" do
        it "leaves the email alone and drops the pending address" do
          user = create(:user, email: "old@example.com", unconfirmed_email: "new@example.com")
          create(:user, email: "new@example.com")

          expect(user.confirm_email_change).to be(false)
          expect(user.reload).to have_attributes(email: "old@example.com", unconfirmed_email: nil)
        end
      end
    end
  end
end
