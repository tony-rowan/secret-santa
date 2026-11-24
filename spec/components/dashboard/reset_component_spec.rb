require "rails_helper"

RSpec.describe Dashboard::ResetComponent, type: :component do
  let(:owner) { create(:user) }
  let(:group) { create(:group, owner:, users: [owner, *create_list(:user, 2)]) }

  context "when the user is the organiser" do
    context "when names have been drawn" do
      before { group.assign_partners }

      it "offers to clear everything for this year" do
        render_inline(described_class.new(group:, user: owner))

        expect(page).to have_css("h2", text: "Reset for this year")
        expect(page).to have_text("Clears drawn names and everyone's gift ideas, ready to start this year's Secret Santa. Members and rules stay.")
        expect(page).to have_css("form[action='/groups/#{group.id}/reset'] button[data-turbo-confirm='Clear everything?'][data-confirm-button='Yes, clear everything']", text: "Clear everything…")
      end

      it "says what goes and what stays" do
        render_inline(described_class.new(group:, user: owner))

        details = template_content("confirm-reset")
        expect(details).to have_text("Everyone's gift ideas are deleted")
        expect(details).to have_text("All 3 members stay in the group")
        expect(details).to have_text("This can't be undone.")
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
