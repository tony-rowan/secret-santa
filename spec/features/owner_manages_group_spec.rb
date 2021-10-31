require "rails_helper"

RSpec.feature "Owner Manages Group" do
  scenario "Sets Secret Santa partners" do
    user = create(:user, login: "username", password: "password")
    other_user = create(:user)
    group = create(:group, owner: user, users: [user, other_user])

    visit(root_path)
    click_on("Log In")
    fill_in(:login, with: "username")
    fill_in(:password, with: "password")
    click_on("Log In")
    visit(group_path(group))
    click_on("Assign Secret Santa Partners")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Hello #{user.name}, you have #{other_user.name} for Secret Santa")
  end
end
