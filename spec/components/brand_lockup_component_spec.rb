require "rails_helper"

RSpec.describe BrandLockupComponent, type: :component do
  it "links the name to the given path and the byline to muddle" do
    render_inline(described_class.new(path: "/somewhere"))

    expect(page).to have_link("Secret Santa", href: "/somewhere")
    expect(page).to have_link("by muddle", href: "https://getmuddle.app")
  end

  context "when the size is unknown" do
    it "raises" do
      expect { described_class.new(path: "/", size: :huge) }.to raise_error(KeyError)
    end
  end
end
