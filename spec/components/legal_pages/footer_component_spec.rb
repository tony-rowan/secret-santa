require "rails_helper"

RSpec.describe LegalPages::FooterComponent, type: :component do
  it "links to the other page and back to the app" do
    render_inline(described_class.new(other_page_text: "Read our terms", other_page_path: "/terms"))

    expect(page).to have_link("Read our terms", href: "/terms")
    expect(page).to have_link("Back to Secret Santa", href: "/")
  end
end
