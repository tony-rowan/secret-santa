require "rails_helper"

RSpec.feature "New User Journey" do
  scenario "A new user signs up, picks a name and creates a group" do
    visit(root_path)
    request_magic_link("trevor@example.com")

    expect(User.count).to eq(0)

    follow_magic_link

    expect(page).to have_current_path(new_display_name_path)

    fill_in("Display name", with: "Trevor Slattery")
    click_on("Continue")

    expect(User.last).to have_attributes(name: "Trevor Slattery", email: "trevor@example.com")
    expect(page).to have_current_path(new_group_path)
    expect(page).to have_css("h1", text: "Start a group")
    expect(page).to have_text("Expecting to join someone else's group? Open the invite link they sent you again.")

    fill_in("Group name", with: "AIM, no wait, The 10 Rings")
    fill_in("Add a rule", with: "No limit, I know you guys can afford it!")
    click_on("Add")
    fill_in("Add a rule", with: "Swap on Christmas Eve")
    click_on("Add")
    fill_in("Add a rule", with: "Remove me")
    click_on("Add")
    click_on("Remove rule: Remove me")
    click_on("Create group")

    group = Group.last
    expect(group).to have_attributes(name: "AIM, no wait, The 10 Rings", owner: User.last, users: [User.last])
    expect(group.rules.map(&:text)).to eq(["No limit, I know you guys can afford it!", "Swap on Christmas Eve"])

    expect(page).to have_current_path(created_group_path(group))

    click_on("Go to your group")

    expect(page).to have_current_path(dashboard_path)

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
end
