require "rails_helper"

RSpec.describe SnowComponent, type: :component do
  it "scatters the flakes" do
    render_inline(described_class.new)

    expect(page).to have_css("div.animate-pulse", count: SnowComponent::FLAKES, visible: :all)
  end
end
