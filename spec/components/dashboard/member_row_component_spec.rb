require "rails_helper"

RSpec.describe Dashboard::MemberRowComponent, type: :component do
  let(:owner) { create(:user, name: "Olive") }
  let(:member) { create(:user, name: "Alex") }
  let(:group) { create(:group, owner:, users: [owner, member]) }

  def render_row(member:, user: owner, idea_count: 0, drawn: false)
    render_inline(described_class.new(group:, member:, user:, idea_count:, drawn:))
  end

  context "when the member has ideas" do
    it "counts them" do
      render_row(member:, idea_count: 2)

      expect(page).to have_css("span.text-lilac-400", text: "2 ideas")
    end
  end

  context "when the member has no ideas" do
    it "flags it" do
      render_row(member:)

      expect(page).to have_css("span.text-gold", text: "No ideas yet")
    end
  end

  context "when the row is the organiser's own" do
    it "says so and can't be removed" do
      render_row(member: owner, idea_count: 1)

      expect(page).to have_text("You · organiser · 1 idea")
      expect(page).to have_no_css("button", text: /Remove/)
    end
  end

  context "when the row is another member's" do
    it "offers to remove them, confirming first" do
      render_row(member:)

      expect(page).to have_button("Remove Alex from the group")
      expect(page).to have_css("button[data-turbo-confirm='Remove Alex?'][data-confirm-button='Yes, remove Alex']")
      details = template_content("confirm-remove-#{member.id}")
      expect(details).to have_text("Alex leaves the group")
      expect(details).to have_text("Alex's gift ideas are deleted")
    end

    context "when names have been drawn" do
      it "warns that removing them clears the draw" do
        render_row(member:, drawn: true)

        expect(template_content("confirm-remove-#{member.id}")).to have_text("Names have already been drawn. Removing Alex clears them")
      end
    end

    context "when names haven't been drawn" do
      it "doesn't warn" do
        render_row(member:)

        expect(template_content("confirm-remove-#{member.id}")).to have_no_text("Names have already been drawn")
      end
    end
  end
end
