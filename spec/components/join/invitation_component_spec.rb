require "rails_helper"

RSpec.describe Join::InvitationComponent, type: :component do
  it "shows the group and its organiser to check before joining" do
    group = create(:group, name: "The 10 Rings", owner: create(:user, name: "Tony"))

    render_inline(described_class.new(group:, form: JoinGroup.new(invite_token: group.invite_token)))

    expect(page).to have_css("h2", text: "The 10 Rings")
    expect(page).to have_text("Organised by Tony")
    expect(page).to have_no_text(group.invite_token)
    expect(page).to have_css("input[type='hidden'][value='#{group.invite_token}']", visible: :all)
    expect(page).to have_button("Join The 10 Rings")
    expect(page).to have_no_link
  end
end
