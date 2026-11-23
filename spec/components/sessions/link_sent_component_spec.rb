require "rails_helper"

RSpec.describe Sessions::LinkSentComponent, type: :component do
  it "says where the link went and how long it works" do
    render_inline(described_class.new(email: "trevor@example.com"))

    expect(page).to have_text("We've sent a sign-in link to trevor@example.com. It works for 15 minutes.")
    expect(page).to have_no_text("Follow it to join")
  end

  context "when there's an invite" do
    it "says the link joins the group too" do
      group = create(:group, name: "The 10 Rings", owner: create(:user, name: "Tony"))

      render_inline(described_class.new(email: "trevor@example.com", group:))

      expect(page).to have_text("Follow it to join Tony's group, The 10 Rings.")
    end
  end
end
