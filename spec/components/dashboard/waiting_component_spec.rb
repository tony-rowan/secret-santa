require "rails_helper"

RSpec.describe Dashboard::WaitingComponent, type: :component do
  context "when the user has no ideas yet" do
    it "makes adding ideas the current step" do
      render_inline(described_class.new(has_ideas: false))

      expect(page).to have_css("li[aria-current='step']", count: 1, text: "Add ideas")
    end
  end

  context "when the user has added ideas" do
    it "makes the draw the current step" do
      render_inline(described_class.new(has_ideas: true))

      expect(page).to have_css("li[aria-current='step']", count: 1, text: "Names drawn")
    end
  end
end
