require "rails_helper"

RSpec.describe Mailer::ButtonComponent, type: :component do
  it "links the button text to the url" do
    render_inline(described_class.new(text: "Sign in", url: "https://example.com/go"))

    expect(page).to have_css("table[role='presentation'] td[bgcolor] a[href='https://example.com/go']", text: "Sign in")
  end
end
