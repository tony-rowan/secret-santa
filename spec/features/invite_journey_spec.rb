require "rails_helper"

RSpec.feature "Invite Journey" do
  scenario "A user signs up after following a link including a join code" do
    owner = create(:user)
    create(
      :group,
      owner: owner,
      name: "AIM, no wait, The 10 Rings",
      rules: "No limit, I know you guys can afford it!",
      join_code: "ABCDEF"
    )

    visit(join_with_code_path("ABCDEF"))
    click_on("Create an Account")
    fill_in("Display Name", with: "Trevor Slattery")
    fill_in("Username", with: "trevor")
    fill_in("Password", with: "the_mandarin")
    click_on("Join")

    expect(User.count).to eq(2)
    expect(User.last).to have_attributes(name: "Trevor Slattery", login: "trevor")

    expect(page).to have_current_path(join_with_code_path("ABCDEF"))
    expect(page).to have_text("Account Created")
    expect(page).to have_text("AIM, no wait, The 10 Rings")

    click_on("Join")

    expect(Group.count).to eq(1)
    expect(Group.last).to have_attributes(
      name: "AIM, no wait, The 10 Rings",
      rules: "No limit, I know you guys can afford it!",
      owner: owner,
      users: [owner, User.last]
    )

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Group Joined")
    expect(page).to have_text("AIM, no wait, The 10 Rings")
    expect(page).to have_text("No limit, I know you guys can afford it!")
    expect(page).to have_text("Trevor Slattery (You)")

    fill_in("Add a gift idea", with: "Case of Fosters")
    click_on("Add")
    fill_in("Add a gift idea", with: "New Liverpool Shirt")
    click_on("Add")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Case of Fosters")
    expect(page).to have_text("New Liverpool Shirt")
  end

  scenario "A user signs in and joins a group after following a link including a join code" do
    user = create(:user, name: "Trevor Slattery", login: "trevor", password: "the_mandarin")
    owner = create(:user)
    create(
      :group,
      owner: owner,
      name: "AIM, no wait, The 10 Rings",
      rules: "No limit, I know you guys can afford it!",
      join_code: "ABCDEF"
    )

    visit(join_with_code_path("ABCDEF"))
    click_on("Sign In")
    fill_in("Username", with: "trevor")
    fill_in("Password", with: "the_mandarin")
    click_on("Join")

    expect(page).to have_current_path(join_with_code_path("ABCDEF"))
    expect(page).to have_text("Signed In")
    expect(page).to have_text("AIM, no wait, The 10 Rings")

    click_on("Join")

    expect(Group.count).to eq(1)
    expect(Group.last).to have_attributes(
      name: "AIM, no wait, The 10 Rings",
      rules: "No limit, I know you guys can afford it!",
      owner: owner,
      users: [owner, user]
    )

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Group Joined")
    expect(page).to have_text("AIM, no wait, The 10 Rings")
    expect(page).to have_text("No limit, I know you guys can afford it!")
    expect(page).to have_text("Trevor Slattery (You)")

    fill_in("Add a gift idea", with: "Case of Fosters")
    click_on("Add")
    fill_in("Add a gift idea", with: "New Liverpool Shirt")
    click_on("Add")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Case of Fosters")
    expect(page).to have_text("New Liverpool Shirt")
  end

  scenario "A signed in user joins a group after following a link including a join code" do
    user = create(:user, name: "Trevor Slattery", login: "trevor", password: "the_mandarin")
    owner = create(:user)
    create(
      :group,
      owner: owner,
      name: "AIM, no wait, The 10 Rings",
      rules: "No limit, I know you guys can afford it!",
      join_code: "ABCDEF"
    )

    visit(root_path)
    click_on("Sign In")
    fill_in("Username", with: "trevor")
    fill_in("Password", with: "the_mandarin")
    click_on("Sign In")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Signed In")
    expect(page).to have_text("You're not part of a group")

    visit(join_with_code_path("ABCDEF"))

    click_on("Join")

    expect(Group.count).to eq(1)
    expect(Group.last).to have_attributes(
      name: "AIM, no wait, The 10 Rings",
      rules: "No limit, I know you guys can afford it!",
      owner: owner,
      users: [owner, user]
    )

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Group Joined")
    expect(page).to have_text("AIM, no wait, The 10 Rings")
    expect(page).to have_text("No limit, I know you guys can afford it!")
    expect(page).to have_text("Trevor Slattery (You)")

    fill_in("Add a gift idea", with: "Case of Fosters")
    click_on("Add")
    fill_in("Add a gift idea", with: "New Liverpool Shirt")
    click_on("Add")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Case of Fosters")
    expect(page).to have_text("New Liverpool Shirt")
  end
end
