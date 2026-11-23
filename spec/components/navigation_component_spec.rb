require "rails_helper"

RSpec.describe NavigationComponent, type: :component do
  it "links the brand to the dashboard" do
    render_inline(described_class.new(user: nil))

    expect(page).to have_link("Secret Santa", href: "/dashboard")
  end

  context "when signed in" do
    it "links to the account page" do
      user = create(:user)

      render_inline(described_class.new(user:))

      expect(page).to have_link("Account", href: "/users/#{user.id}/edit")
    end
  end

  context "when signed out" do
    it "has no account link" do
      render_inline(described_class.new(user: nil))

      expect(page).to have_no_link("Account")
    end
  end
end
