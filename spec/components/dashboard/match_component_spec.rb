require "rails_helper"

RSpec.describe Dashboard::MatchComponent, type: :component do
  let(:owner) { create(:user) }
  let(:match) { create(:user, name: "Alex") }
  let(:group) { create(:group, owner:, users: [owner, match, create(:user)]) }
  let(:pair) { create(:pair, group:, user: owner, other: match) }

  it "shows the match's ideas for this group only" do
    create(:idea, group:, user: match, idea: "Anything chocolate")
    create(:idea, user: match, idea: "From another group")

    render_inline(described_class.new(pair:, owner: false))

    expect(page).to have_css("h3", text: "Alex's ideas")
    expect(page).to have_css("li", text: "Anything chocolate")
    expect(page).to have_no_text("From another group")
  end

  context "when the match has no ideas" do
    it "says so" do
      render_inline(described_class.new(pair:, owner: false))

      expect(page).to have_text("They haven't added any gift ideas yet.")
      expect(page).to have_no_css("li")
    end
  end

  context "when the user is the organiser" do
    it "offers a redraw that confirms first" do
      render_inline(described_class.new(pair:, owner: true))

      expect(page).to have_css("button[data-turbo-confirm='Draw names again?'][data-confirm-button='Yes, draw again']", text: "Draw names again")
      expect(template_content("confirm-redraw")).to have_text("Everyone gets a new person, including you")
    end
  end

  context "when the user is a member" do
    it "has no redraw" do
      render_inline(described_class.new(pair:, owner: false))

      expect(page).to have_no_button("Draw names again")
    end
  end
end
