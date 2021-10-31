require "rails_helper"

RSpec.feature "User Joins Group" do
  scenario "Invited visitor can still join a group after failing validations" do
    group = create(:group)

    visit(invite_path(group.invite_token))
    click_on("Create an Account")
    click_on("Join")

    expect(page).to have_text("Could not create account becuase:")

    fill_in(:user_name, with: "Trevor Slattery")
    fill_in(:user_login, with: "trevor")
    fill_in(:user_password, with: "the_mandarin")
    click_on("Join")

    expect(User.count).to eq(2)
    expect(User.last.name).to eq("Trevor Slattery")
    expect(User.last.login).to eq("trevor")
    expect(User.last.groups).to eq([Group.last])
    expect(User.last.owned_groups).to eq([])
    expect(Group.count).to eq(1)
    expect(Group.last.users).to eq(User.all)

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Trevor Slattery")
  end

  scenario "Invited user can join a group when they're signed in" do
    user = create(:user, login: "username", password: "password")
    group = create(:group)

    visit(root_path)
    click_on("Log In")
    fill_in(:login, with: "username")
    fill_in(:password, with: "password")
    click_on("Log In")
    visit(invite_path(group.invite_token))

    expect(page).to have_text("Join #{group.owner.name}'s Secret Santa group #{group.name}")

    click_on("Join Group")

    expect(user.groups).to eq([group])

    expect(page).to have_current_path(group_path(Group.last))
    expect(page).to have_text("#{user.name} (You)")
  end
end
