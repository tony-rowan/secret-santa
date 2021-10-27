require "rails_helper"

RSpec.feature "Getting Started" do
  scenario "Vistor creates and account and a group with rules" do
    visit(root_path)
    click_on("Create a Group")
    fill_in(:user_name, with: "Trevor Slattery")
    fill_in(:user_login, with: "trevor")
    fill_in(:user_password, with: "the_mandarin")
    fill_in(:user_groups_attributes_0_name, with: "AIM, no wait, The 10 Rings")
    fill_in(:user_groups_attributes_0_rules, with: "No limit, I know you guys can afford it!")
    click_on("Get Started")

    expect(page).to have_current_path(group_path(Group.last))
    expect(page).to have_text("AIM, no wait, The 10 Rings")
    expect(page).to have_text("No limit, I know you guys can afford it!")
    expect(page).to have_text("Trevor Slattery")
    expect(page).to have_text("Right click to copy this link and share it to invite people to your group")
  end
end
