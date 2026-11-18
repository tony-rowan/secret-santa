require "rails_helper"

RSpec.feature "Group Management" do
  scenario "The owner edits the group name, rules, then assigns and shuffles secret santas and kicks someone" do
    owner = create(:user)
    kicked_user = create(:user, name: "Bad Actor")
    other_users = create_list(:user, 3)
    group = create(
      :group,
      owner: owner,
      users: [owner, kicked_user, *other_users],
      name: "Old Group Name",
      rules: "Old Group Rules"
    )

    sign_in(owner)

    expect(page).to have_text("Old Group Name")
    expect(page).to have_text("Old Group Rules")
    expect(page).to have_text("Not Started")

    click_on("Manage Group")
    fill_in("Name", with: "New Group Name")
    fill_in("Rules", with: "New Group Rules with **bold** text\n\n- First rule\n- Second rule")
    click_on("Update Group")

    expect(page).to have_text("New Group Name")

    group.reload
    expect(group.name).to eq("New Group Name")
    expect(group.rules).to eq("New Group Rules with **bold** text\n\n- First rule\n- Second rule")
    expect(group.pairs).to be_empty

    expect(page).to have_text("New Group Name")
    expect(page).to have_text("New Group Rules")
    expect(page).to have_css("strong", text: "bold")
    expect(page).to have_css("li", text: "First rule")
    expect(page).to have_css("li", text: "Second rule")
    expect(page).to have_text("Not Started")

    click_on("Assign Secret Santa Partners")

    expect(page).to have_text("Secret Santa partners assigned!")

    pair_ids = group.pairs.pluck(:id)
    expect(pair_ids.count).to eq(5)

    expect(page).to have_text("Secret Santa partners assigned!")
    expect(page).to have_text("New Group Name")
    expect(page).to have_text("New Group Rules")
    expect(page).to have_text("Now buy them some gifts!")

    click_on("Shuffle Secret Santa Partners")

    expect(page).to have_text("Secret Santa partners re-assigned!")

    shuffled_pair_ids = group.pairs.pluck(:id)
    expect(shuffled_pair_ids).not_to eq(pair_ids)
    expect(shuffled_pair_ids.count).to eq(5)

    expect(page).to have_text("Secret Santa partners re-assigned!")
    expect(page).to have_text("New Group Name")
    expect(page).to have_text("New Group Rules")
    expect(page).to have_text("Now buy them some gifts!")

    accept_confirm { click_on("Kick Bad Actor") }

    expect(page).to have_text("Removed Bad Actor from the group!")

    expect(group.pairs.count).to eq(0)
    expect(group.users).not_to include(kicked_user)

    expect(page).to have_text("Removed Bad Actor from the group!")
    expect(page).to have_text("Secret santa partners have been un-assigned")
    expect(page).to have_text("Not Started")
  end

  scenario "The owner resets the group for next year" do
    owner = create(:user)
    member = create(:user)
    other_member = create(:user)
    group = create(:group, owner:, users: [owner, member, other_member])
    group.assign_partners
    create(:idea, group:, user: owner, idea: "Socks")
    create(:idea, group:, user: member, idea: "Mug")

    sign_in(owner)

    expect(page).to have_text("Now buy them some gifts!")

    click_on("Manage Group")

    expect(page).to have_text("Manage #{group.name}")
    expect(page).to have_text("3 pairings")
    expect(page).to have_text("2 gift ideas")

    accept_confirm { click_on("Remove secret santa pairings") }

    expect(page).to have_text("Secret santa pairings removed")
    expect(page).to have_text("0 pairings")
    expect(group.pairs.count).to eq(0)

    accept_confirm { click_on("Remove all gift ideas") }

    expect(page).to have_text("Gift ideas removed")
    expect(page).to have_text("0 gift ideas")
    expect(group.ideas.count).to eq(0)

    visit dashboard_path

    expect(page).to have_text("Not Started")
  end
end
