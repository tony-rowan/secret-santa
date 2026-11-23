require "rails_helper"

RSpec.describe Groups::InviteButtonsComponent, type: :component do
  it "copies the code and shares the join link" do
    group = create(:group)

    render_inline(described_class.new(group:))

    expect(page).to have_css("button[data-clipboard-text-value='#{group.formatted_join_code}']", text: "Copy code")
    link = page.find_link("Share link", href: "http://test.host/join/#{group.formatted_join_code}")
    expect(JSON.parse(link["data-share-data-value"])).to include("url" => "http://test.host/join/#{group.formatted_join_code}")
  end
end
