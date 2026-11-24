require "rails_helper"

RSpec.feature "Invite Journey" do
  scenario "A new user signs up after following an invite link" do
    owner = create(:user, name: "Tony")
    group = create(
      :group,
      owner: owner,
      name: "AIM, no wait, The 10 Rings",
      rule_texts: ["No limit, I know you guys can afford it!"]
    )

    visit(invite_path(group.invite_token))
    request_magic_link("trevor@example.com")
    follow_magic_link
    fill_in("Display name", with: "Trevor Slattery")
    click_on("Continue")

    expect(page).to have_current_path(join_path)
    expect(page).to have_css("h1", text: "You're invited")

    click_on("Join AIM, no wait, The 10 Rings")

    expect(group.reload.users).to eq([owner, User.last])
    expect(User.last).to have_attributes(name: "Trevor Slattery", email: "trevor@example.com")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_css("h1", text: "AIM, no wait, The 10 Rings")
  end

  scenario "An existing user signs in after following an invite link" do
    user = create(:user, name: "Trevor Slattery", email: "trevor@example.com")
    owner = create(:user)
    group = create(:group, owner: owner, name: "AIM, no wait, The 10 Rings")

    visit(invite_path(group.invite_token))
    request_magic_link("trevor@example.com")
    follow_magic_link

    expect(page).to have_current_path(invite_path(group.invite_token))
    expect(page).to have_css("h1", text: "You're invited")

    click_on("Join AIM, no wait, The 10 Rings")

    expect(group.reload.users).to eq([owner, user])
    expect(page).to have_current_path(dashboard_path)
  end

  scenario "A signed in user follows an invite link" do
    user = create(:user, name: "Trevor Slattery")
    owner = create(:user)
    group = create(:group, owner: owner, name: "AIM, no wait, The 10 Rings")

    sign_in(user)

    expect(page).to have_css("h1", text: "Start a group")

    visit(invite_path(group.invite_token))
    click_on("Join AIM, no wait, The 10 Rings")

    expect(group.reload.users).to eq([owner, user])
    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_css("h1", text: "AIM, no wait, The 10 Rings")
  end

  scenario "Someone follows an invite link after names are drawn" do
    owner = create(:user, name: "Tony")
    group = create(:group, owner:, name: "Rowans", users: [owner, *create_list(:user, 2)])
    group.assign_partners

    authenticate(create(:user))
    visit(invite_path(group.invite_token))

    expect(page).to have_css("h1", text: "Names have been drawn")
    expect(group.reload.users.count).to eq(3)
  end

  scenario "An organiser copies the invite link from the dialog" do
    owner = create(:user)
    group = create(:group, owner:, users: [owner])

    authenticate(owner)
    visit(dashboard_path)
    # Headless Chrome may or may not have a share sheet; without one the dialog opens
    page.execute_script("Object.defineProperty(navigator, 'share', { value: undefined })")
    click_on("Invite others")

    within("dialog[open]") do
      expect(find_field("Invite link").value).to end_with(invite_path(group.invite_token))
      click_on("Done")
    end

    expect(page).to have_no_css("dialog[open]")
  end
end
