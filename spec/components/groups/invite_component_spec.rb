require "rails_helper"

RSpec.describe Groups::InviteComponent, type: :component do
  let(:group) { create(:group, name: "Rowans") }

  it "shows an Invite others button that shares the invite link" do
    render_inline(described_class.new(group:))

    expect(page).to have_button("Invite others", class: "button-secondary")
    share = JSON.parse(page.find("[data-controller='invite']")["data-invite-share-value"])
    expect(share).to include("title" => "Secret Santa", "text" => "Join Rowans for Secret Santa")
    expect(share["url"]).to match(%r{\Ahttps?://[^/]+/join/#{group.invite_token}\z})
  end

  it "has a dialog explaining the link, to copy it from" do
    render_inline(described_class.new(group:))

    dialog = page.find("dialog", visible: :all)
    expect(dialog).to have_css("h2", text: "Invite others", visible: :all)
    expect(dialog).to have_text("Send this link to everyone you want in Rowans, by message or email. Opening it lets them join.", exact: false)
    expect(dialog).to have_field("Invite link", with: %r{/join/#{group.invite_token}\z}, readonly: true, visible: :all)
    expect(dialog).to have_text("The link works until you draw names. After that, no one new can join.", exact: false)
    expect(dialog).to have_button("Copy link", visible: :all)
    expect(dialog).to have_button("Done", visible: :all)
    expect(dialog).to have_css("button[aria-label='Close']", visible: :all)
  end

  context "when it's the main action" do
    it "is a primary button" do
      render_inline(described_class.new(group:, primary: true))

      expect(page).to have_button("Invite others", class: "button")
      expect(page).to have_no_css("button.button-secondary", text: "Invite others")
    end
  end
end
