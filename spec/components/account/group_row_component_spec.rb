require "rails_helper"

RSpec.describe Account::GroupRowComponent, type: :component do
  let(:user) { create(:user) }

  context "when the user organises the group" do
    it "says so and has no Leave button" do
      group = create(:group, name: "Rowans", owner: user)

      render_inline(described_class.new(group:, user:))

      expect(page).to have_css("a", text: /Rowans\s+Organised by you/)
      expect(page).to have_no_button("Leave Rowans")
    end
  end

  context "when someone else organises the group" do
    let(:group) { create(:group, name: "Book club", owner: create(:user, name: "Sam"), users: [user]) }

    it "names the organiser and offers to leave, confirming first" do
      render_inline(described_class.new(group:, user:))

      expect(page).to have_css("a", text: /Book club\s+Organised by Sam/)
      expect(page).to have_css("button[data-turbo-confirm='Leave Book club?'][data-confirm-button='Yes, leave']", text: "Leave")
      details = template_content("confirm-leave-#{group.id}")
      expect(details).to have_text("You leave Book club")
      expect(details).to have_text("You can join again with the code.")
    end

    context "when names have been drawn" do
      it "warns that leaving clears the draw" do
        create(:pair, group:, user:)

        render_inline(described_class.new(group:, user:))

        expect(template_content("confirm-leave-#{group.id}")).to have_text("Drawn names are cleared")
      end
    end

    context "when names haven't been drawn" do
      it "doesn't warn" do
        render_inline(described_class.new(group:, user:))

        expect(template_content("confirm-leave-#{group.id}")).to have_no_text("Drawn names are cleared")
      end
    end
  end
end
