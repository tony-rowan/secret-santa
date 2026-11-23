require "rails_helper"

RSpec.describe Sessions::InvitationNoteComponent, type: :component do
  context "when there's an invite" do
    it "says who invited the user to what" do
      group = create(:group, name: "The 10 Rings", owner: create(:user, name: "Tony"))

      render_inline(described_class.new(group:))

      expect(page).to have_text("Tony invited you to The 10 Rings. Sign in to join.")
    end
  end

  context "when there's no invite" do
    it "renders nothing" do
      render_inline(described_class.new(group: nil))

      expect(rendered_content).to be_blank
    end
  end
end
