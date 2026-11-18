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
end
