require "rails_helper"

RSpec.describe Mailer::LinkDetailsComponent, type: :component do
  it "says when the link expires and spells it out" do
    render_inline(described_class.new(expiry: "This link works for 1 hour.", url: "https://example.com/go"))

    expect(page).to have_text("This link works for 1 hour.")
    expect(page).to have_text("Button not working?")
    expect(page).to have_link("https://example.com/go", href: "https://example.com/go")
  end
end
