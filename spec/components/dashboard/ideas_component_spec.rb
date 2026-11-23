require "rails_helper"

RSpec.describe Dashboard::IdeasComponent, type: :component do
  context "when the user has ideas" do
    it "lists them with remove buttons" do
      idea = create(:idea, idea: "Fluffy socks")

      render_inline(described_class.new(ideas: [idea], drawn: false))

      expect(page).to have_css("li", text: "Fluffy socks")
      expect(page).to have_button("Remove Fluffy socks")
      expect(page).to have_field("Add a gift idea", placeholder: "Add an idea…")
    end
  end

  context "when the user has no ideas" do
    it "shows the empty state" do
      render_inline(described_class.new(ideas: [], drawn: false))

      expect(page).to have_text("No ideas yet")
      expect(page).to have_no_css("li")
      expect(page).to have_field("Add a gift idea", placeholder: "e.g. Fluffy socks")
    end
  end

  context "when names haven't been drawn" do
    it "says only their Secret Santa will see them" do
      render_inline(described_class.new(ideas: [], drawn: false))

      expect(page).to have_text("Only your Secret Santa will see these.")
    end
  end

  context "when names have been drawn" do
    it "says their Secret Santa can see them now" do
      render_inline(described_class.new(ideas: [], drawn: true))

      expect(page).to have_text("Keep adding — your Secret Santa can see these now.")
    end
  end
end
