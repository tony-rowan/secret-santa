require "rails_helper"

RSpec.feature "Group Management" do
  scenario "The owner edits the group name, rules, then assigns and shuffles secret santas and kicks someone" do
    owner = create(:user, login: "username", password: "password")
    kicked_user = create(:user, name: "Bad Actor")
    other_users = create_list(:user, 3)
    group = create(
      :group,
      owner: owner,
      users: [owner, kicked_user, *other_users],
      name: "Old Group Name",
      rules: "Old Group Rules"
    )

    visit(root_path)
    click_on("Sign In")
    fill_in("Username", with: "username")
    fill_in("Password", with: "password")
    click_on("Sign In")

    expect(page).to have_text("Old Group Name")
    expect(page).to have_text("Old Group Rules")
    expect(page).to have_text("Not Started")

    click_on("Edit Group")
    fill_in("Name", with: "New Group Name")
    fill_in("Rules", with: "New Group Rules")
    click_on("Update Group")

    group.reload
    expect(group.name).to eq("New Group Name")
    expect(group.rules).to eq("New Group Rules")
    expect(group.pairs).to be_empty

    expect(page).to have_text("New Group Name")
    expect(page).to have_text("New Group Rules")
    expect(page).to have_text("Not Started")

    click_on("Assign Secret Santa Partners")

    pair_ids = group.pairs.pluck(:id)
    expect(pair_ids.count).to eq(5)

    expect(page).to have_text("Secret Santa partners assigned!")
    expect(page).to have_text("New Group Name")
    expect(page).to have_text("New Group Rules")
    expect(page).to have_text("Now buy them some gifts!")

    click_on("Shuffle Secret Santa Partners")

    shuffled_pair_ids = group.pairs.pluck(:id)
    expect(shuffled_pair_ids).not_to eq(pair_ids)
    expect(shuffled_pair_ids.count).to eq(5)

    expect(page).to have_text("Secret Santa partners re-assigned!")
    expect(page).to have_text("New Group Name")
    expect(page).to have_text("New Group Rules")
    expect(page).to have_text("Now buy them some gifts!")

    click_on("Kick Bad Actor")

    expect(group.pairs.count).to eq(0)
    expect(group.users).not_to include(kicked_user)

    expect(page).to have_text("Kicked Bad Actor out of the group! Partners have been un-assigned.")
    expect(page).to have_text("Not Started")
  end
end
