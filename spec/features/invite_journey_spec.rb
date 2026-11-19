require "rails_helper"

RSpec.feature "Invite Journey" do
  scenario "A new user signs up after following an invite link" do
    owner = create(:user, name: "Tony")
    create(
      :group,
      owner: owner,
      name: "AIM, no wait, The 10 Rings",
      rule_texts: ["No limit, I know you guys can afford it!"],
      join_code: "ABCDEF"
    )

    visit(join_with_code_path("ABCDEF"))

    expect(page).to have_text("Tony invited you to AIM, no wait, The 10 Rings")

    request_magic_link("trevor@example.com")
    follow_magic_link
    fill_in("Display name", with: "Trevor Slattery")
    click_on("Continue")

    expect(page).to have_current_path(join_path)
    expect(page).to have_text("You're invited")
    expect(page).to have_text("Organised by Tony")

    click_on("Join AIM, no wait, The 10 Rings")

    expect(Group.last.users).to eq([owner, User.last])
    expect(User.last).to have_attributes(name: "Trevor Slattery", email: "trevor@example.com")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("No limit, I know you guys can afford it!")
    expect(page).to have_text("Trevor Slattery (you)")
  end

  scenario "An existing user signs in after following an invite link" do
    user = create(:user, name: "Trevor Slattery", email: "trevor@example.com")
    owner = create(:user)
    create(:group, owner: owner, name: "AIM, no wait, The 10 Rings", join_code: "ABCDEF")

    visit(join_with_code_path("ABCDEF"))
    request_magic_link("trevor@example.com")
    follow_magic_link

    expect(page).to have_current_path(join_with_code_path("ABCDEF"))
    expect(page).to have_text("You're invited")

    click_on("Join AIM, no wait, The 10 Rings")

    expect(Group.last.users).to eq([owner, user])
    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Trevor Slattery (you)")
  end

  scenario "A signed in user follows an invite link" do
    user = create(:user, name: "Trevor Slattery")
    owner = create(:user)
    create(:group, owner: owner, name: "AIM, no wait, The 10 Rings", join_code: "ABCDEF")

    sign_in(user)

    expect(page).to have_css("h1", text: "Join a group")

    visit(join_with_code_path("ABCDEF"))
    click_on("Join AIM, no wait, The 10 Rings")

    expect(Group.last.users).to eq([owner, user])
    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_css("h1", text: "AIM, no wait, The 10 Rings")
  end

  scenario "A signed in user chooses a different code" do
    user = create(:user)
    create(:group, join_code: "ABCDEF")

    authenticate(user)
    visit(join_with_code_path("ABCDEF"))
    click_on("Use a different code")

    expect(page).to have_text("Enter the code your organiser shared with you")
    expect(page).to have_field("Join Code", with: "")
  end
end
