require "rails_helper"

RSpec.describe Join::InvitationComponent, type: :component do
  it "shows the group to check before joining it" do
    group = create(:group, name: "The 10 Rings", owner: create(:user, name: "Tony"))

    render_inline(described_class.new(group:, form: JoinGroup.new(join_code: group.join_code)))

    expect(page).to have_css("h2", text: "The 10 Rings")
    expect(page).to have_text("Organised by Tony")
    expect(page).to have_text(group.formatted_join_code)
    expect(page).to have_css("input[type='hidden'][value='#{group.join_code}']", visible: :all)
    expect(page).to have_button("Join The 10 Rings")
    expect(page).to have_link("Use a different code")
  end
end
