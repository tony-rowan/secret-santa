require "rails_helper"

RSpec.feature "Homepage" do
  scenario "Vistor can go to login" do
    visit(root_path)
    click_on("Log In")

    expect(page).to have_current_path(new_session_path)
    expect(page).to have_field("login")
    expect(page).to have_field("password")
  end

  scenario "Vistor can go to create account and group" do
    visit(root_path)
    click_on("Create a Group")

    expect(page).to have_current_path(new_user_path)
    expect(page).to have_field("user[name]")
    expect(page).to have_field("user[login]")
    expect(page).to have_field("user[password]")
    expect(page).to have_field("user[groups_attributes][0][name]")
    expect(page).to have_field("user[groups_attributes][0][rules]")
  end
end
