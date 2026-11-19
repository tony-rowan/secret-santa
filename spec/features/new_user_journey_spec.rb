require "rails_helper"

RSpec.feature "New User Journey" do
  scenario "A new user signs up, picks a name and creates a group" do
    visit(root_path)
    request_magic_link("trevor@example.com")

    expect(User.count).to eq(0)

    follow_magic_link

    expect(page).to have_current_path(new_display_name_path)
    expect(page).to have_text("What should we call you?")

    fill_in("Display name", with: "Trevor Slattery")
    click_on("Continue")

    expect(User.last).to have_attributes(name: "Trevor Slattery", email: "trevor@example.com")
    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Welcome, Trevor Slattery!")
    expect(page).to have_text("You're not part of a group")
    expect(page).to have_link("Join a group")

    click_on("Start a new group")
    fill_in("Group name", with: "AIM, no wait, The 10 Rings")
    fill_in("Add a rule", with: "No limit, I know you guys can afford it!")
    click_on("Add")
    fill_in("Add a rule", with: "Swap on Christmas Eve")
    click_on("Add")
    fill_in("Add a rule", with: "Remove me")
    click_on("Add")
    click_on("Remove rule: Remove me")
    click_on("Create Group")

    group = Group.last
    expect(group).to have_attributes(name: "AIM, no wait, The 10 Rings", owner: User.last, users: [User.last])
    expect(group.rules.map(&:text)).to eq(["No limit, I know you guys can afford it!", "Swap on Christmas Eve"])

    expect(page).to have_current_path(created_group_path(group))
    expect(page).to have_text("AIM, no wait, The 10 Rings is ready")
    expect(page).to have_text(group.join_code)

    click_on("Go to your group")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("No limit, I know you guys can afford it!")
    expect(page).to have_text("You · organiser")

    within("section[aria-labelledby='ideas-heading']") do
      fill_in("Add a gift idea", with: "Case of Fosters")
      click_on("Add")
      fill_in("Add a gift idea", with: "New Liverpool Shirt")
      click_on("Add")
    end

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Case of Fosters")
    expect(page).to have_text("New Liverpool Shirt")
  end

  scenario "A new user signs up and joins a group by entering a join code" do
    owner = create(:user)
    create(
      :group,
      owner: owner,
      name: "AIM, no wait, The 10 Rings",
      rule_texts: ["No limit, I know you guys can afford it!"],
      join_code: "ABCDEF"
    )

    visit(root_path)
    request_magic_link("trevor@example.com")
    follow_magic_link
    fill_in("Display name", with: "Trevor Slattery")
    click_on("Continue")

    click_on("Join a group")
    fill_in("Join Code", with: "ABCDEF")
    click_on("Join group")

    expect(Group.last.users).to eq([owner, User.last])

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Group Joined")
    expect(page).to have_text("AIM, no wait, The 10 Rings")
    expect(page).to have_text("No limit, I know you guys can afford it!")
    expect(page).to have_text("Trevor Slattery (you)")

    fill_in("Add a gift idea", with: "Case of Fosters")
    click_on("Add")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Case of Fosters")
  end
end
