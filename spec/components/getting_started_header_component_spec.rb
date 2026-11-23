require "rails_helper"

RSpec.describe GettingStartedHeaderComponent, type: :component do
  context "when there's no title" do
    it "shows the brand and says who makes it" do
      render_inline(described_class.new)

      expect(page).to have_css("h1", text: "Secret Santa")
      expect(page).to have_link("by muddle", href: "https://getmuddle.app")
      expect(page).to have_css("svg.icon-gift")
    end
  end

  context "when there's a title, icon and subtitle" do
    it "shows them without the byline" do
      render_inline(described_class.new(icon: "envelope", title: "Check your email", subtitle: "We sent a link."))

      expect(page).to have_css("h1", text: "Check your email")
      expect(page).to have_css("svg.icon-envelope")
      expect(page).to have_css("p", text: "We sent a link.")
      expect(page).to have_no_link("by muddle")
    end
  end

  context "when glowing" do
    it "rings the icon tile" do
      render_inline(described_class.new(glow: true))

      expect(page).to have_css("span.ring-8")
    end
  end
end
