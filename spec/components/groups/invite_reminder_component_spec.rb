require "rails_helper"

RSpec.describe Groups::InviteReminderComponent, type: :component do
  context "when the user has no groups" do
    it "points them back to their invite link" do
      render_inline(described_class.new(user: create(:user)))

      expect(page).to have_text("Expecting to join someone else's group? Open the invite link they sent you again.")
    end
  end

  context "when the user is in a group" do
    it "isn't shown" do
      render_inline(described_class.new(user: create(:user, :with_group)))

      expect(page).to have_no_text("Expecting to join")
    end
  end
end
