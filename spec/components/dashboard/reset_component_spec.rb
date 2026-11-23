require "rails_helper"

RSpec.describe Dashboard::ResetComponent, type: :component do
  context "when the user is the organiser" do
    it "offers to clear everything, saying what goes and what stays" do
      owner = create(:user)
      group = create(:group, owner:, users: [owner, *create_list(:user, 2)])

      render_inline(described_class.new(group:, user: owner))

      expect(page).to have_css("button[data-turbo-confirm='Clear everything?'][data-confirm-button='Yes, clear everything']", text: "Clear everything…")
      details = template_content("confirm-reset")
      expect(details).to have_text("Everyone's gift ideas are deleted")
      expect(details).to have_text("All 3 members stay in the group")
      expect(details).to have_text("This can't be undone.")
    end
  end

  context "when the user is a member" do
    it "renders nothing" do
      member = create(:user)
      group = create(:group, users: [member])

      render_inline(described_class.new(group:, user: member))

      expect(rendered_content).to be_blank
    end
  end
end
