require "rails_helper"

RSpec.describe LegalPages::HeaderComponent, type: :component do
  it "shows the title, when it last changed and the short version" do
    render_inline(described_class.new(title: "Privacy policy", summary: "We never sell your data."))

    expect(page).to have_css("h1", text: "Privacy policy")
    expect(page).to have_text("Last updated #{LegalPages::HeaderComponent::LAST_UPDATED}")
    expect(page).to have_text("The short version We never sell your data.")
  end
end
