require "rails_helper"

RSpec.describe Dashboard::ResetDrawComponent, type: :component do
  let(:owner) { create(:user) }
  let(:group) { create(:group, owner:, users: [owner, *create_list(:user, 2)]) }

  context "when the user is the organiser" do
    context "when names have been drawn" do
      before { group.assign_partners }

      it "offers to reset names" do
        render_inline(described_class.new(group:, user: owner))

        expect(page).to have_css("h2", text: "Reset names")
        expect(page).to have_text("Clears the drawn names so more people can join, or so you can draw again if the match-ups didn't work out. Gift ideas stay.")
        expect(page).to have_css("form[action='/groups/#{group.id}/draw_reset'] button[data-turbo-confirm='Reset names?'][data-confirm-button='Yes, reset names']", text: "Reset names…")
      end

      it "says the ideas stay and the invite link reopens" do
        render_inline(described_class.new(group:, user: owner))

        details = template_content("confirm-reset-draw")
        expect(details).to have_text("Drawn names are cleared")
        expect(details).to have_text("Everyone's gift ideas stay")
        expect(details).to have_text("All 3 members stay in the group")
        expect(details).to have_text("The invite link works again until you draw names.")
      end
    end

    context "when names haven't been drawn" do
      it "renders nothing" do
        render_inline(described_class.new(group:, user: owner))

        expect(rendered_content).to be_blank
      end
    end
  end

  context "when the user is a member" do
    it "renders nothing" do
      group.assign_partners

      render_inline(described_class.new(group:, user: group.users.last))

      expect(rendered_content).to be_blank
    end
  end
end
