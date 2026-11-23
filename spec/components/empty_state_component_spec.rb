require "rails_helper"

RSpec.describe EmptyStateComponent, type: :component do
  it "shows the illustration, title and text" do
    render_inline(described_class.new(title: "No ideas yet", text: "Add some.")) { "<svg></svg>".html_safe }

    expect(page).to have_css("svg")
    expect(page).to have_css("p", text: "No ideas yet")
    expect(page).to have_css("p", text: "Add some.")
  end
end
