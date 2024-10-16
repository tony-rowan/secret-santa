require "rails_helper"

RSpec.feature "New User Journey" do
  scenario "Creating a Group" do
    visit(root_path)
    click_on("Create an Account")
    fill_in(:user_name, with: "Trevor Slattery")
    fill_in(:user_login, with: "trevor")
    fill_in(:user_password, with: "the_mandarin")
    fill_in(:user_groups_attributes_0_name, with: "AIM, no wait, The 10 Rings")
    fill_in(:user_groups_attributes_0_rules, with: "No limit, I know you guys can afford it!")
    click_on("Get Started")

    expect(User.count).to eq(1)
    expect(User.last.name).to eq("Trevor Slattery")
    expect(User.last.login).to eq("trevor")
    expect(User.last.groups).to eq([Group.last])
    expect(User.last.owned_groups).to eq([Group.last])
    expect(Group.count).to eq(1)
    expect(Group.last.name).to eq("AIM, no wait, The 10 Rings")
    expect(Group.last.rules).to eq("No limit, I know you guys can afford it!")
    expect(Group.last.owner).to eq(User.last)
    expect(Group.last.users).to eq([User.last])

    expect(page).to have_current_path(group_path(Group.last))
    expect(page).to have_text("AIM, no wait, The 10 Rings")
    expect(page).to have_text("No limit, I know you guys can afford it!")
    expect(page).to have_text("Trevor Slattery")
    expect(page).to have_text("Click to copy a link that you can share to invite people to your group")
  end

  scenario "Joining a Group" do
    group = create(:group, rules: "£35 limit, must include a gag gift")

    visit(invite_path(group.invite_token))
    click_on("Create an Account")
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
    expect(page).to have_text("Secret Santa partners have not been set yet")
    expect(page).to have_text(group.name)
    expect(page).to have_text(group.rules)
    expect(page).to have_text("Add an idea to help your Secret Santa partner")

    fill_in(:idea, with: "Case of Fosters")
    click_on("Add")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Case of Fosters")

    fill_in(:idea, with: "New Liverpool Shirt")
    click_on("Add")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Case of Fosters")
    expect(page).to have_text("New Liverpool Shirt")
  end
end
