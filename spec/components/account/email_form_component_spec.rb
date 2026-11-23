require "rails_helper"

RSpec.describe Account::EmailFormComponent, type: :component do
  it "shows the email the user signs in with and asks for a new one" do
    user = create(:user, email: "old@example.com")

    render_inline(described_class.new(user:))

    expect(page).to have_text("You sign in with old@example.com")
    expect(page).to have_css("input#user_email:not([value])")
    expect(page).to have_button("Send verification link")
  end

  context "when the new address was rejected" do
    it "keeps it in the field and shows why" do
      user = create(:user)
      user.errors.add(:email, "Too many attempts")

      render_inline(described_class.new(user:, new_email: "new@example.com"))

      expect(page).to have_field("New email address", with: "new@example.com")
      expect(page).to have_css("p.text-berry-light", text: "Too many attempts")
    end
  end

  context "when a change is pending" do
    it "shows it" do
      user = create(:user, unconfirmed_email: "new@example.com")

      render_inline(described_class.new(user:))

      expect(page).to have_text("Waiting for you to verify new@example.com")
    end
  end
end
