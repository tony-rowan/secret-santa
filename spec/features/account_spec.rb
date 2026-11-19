require "rails_helper"

RSpec.feature "Account" do
  scenario "A user renames themselves from the account page" do
    user = create(:user, name: "Bob")

    authenticate(user)
    visit(dashboard_path)
    click_on("Account")
    fill_in("How you appear to your groups", with: "Robert")
    click_on("Save")

    expect(page).to have_current_path(edit_user_path(user))
    expect(page).to have_field("How you appear to your groups", with: "Robert")
  end

  scenario "A user opens one of their groups" do
    user = create(:user)
    create(:group, name: "Rowans", owner: user)
    create(:group, name: "Book club", users: [user])

    authenticate(user)
    visit(edit_user_path(user))
    click_link("Book club")

    expect(page).to have_css("h1", text: "Book club")
  end

  scenario "A user leaves a group" do
    user = create(:user)
    create(:group, name: "Book club", users: [user])

    authenticate(user)
    visit(edit_user_path(user))
    click_on("Leave Book club")
    confirm_dialog("Yes, leave")

    expect(page).to have_current_path(edit_user_path(user))
    expect(page).to have_text("No groups yet")
  end

  scenario "A user deletes their account" do
    user = create(:user)

    authenticate(user)
    visit(edit_user_path(user))
    click_on("Delete my account…")
    confirm_dialog("Yes, delete my account")

    expect(page).to have_text("Your account has been deleted")
    expect(User.exists?(user.id)).to be(false)
  end
end
