require "rails_helper"

RSpec.describe Account::PendingEmailComponent, type: :component do
  context "when a change is pending" do
    it "offers to resend or cancel it" do
      user = create(:user, unconfirmed_email: "new@example.com")

      render_inline(described_class.new(user:))

      expect(page).to have_css("[role='status']", text: "Waiting for you to verify new@example.com")
      expect(page).to have_button("Resend")
      expect(page).to have_button("Cancel change")
    end
  end

  context "when nothing is pending" do
    it "renders nothing" do
      render_inline(described_class.new(user: create(:user)))

      expect(rendered_content).to be_blank
    end
  end
end
