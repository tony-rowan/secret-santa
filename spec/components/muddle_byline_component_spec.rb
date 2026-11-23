require "rails_helper"

RSpec.describe MuddleBylineComponent, type: :component do
  it "links to muddle" do
    render_inline(described_class.new)

    expect(page).to have_link("by muddle", href: "https://getmuddle.app")
  end

  context "when large" do
    it "uses the large wordmark" do
      render_inline(described_class.new(large: true))

      expect(page).to have_css("span.text-\\[22px\\]", text: "muddle")
    end
  end
end
