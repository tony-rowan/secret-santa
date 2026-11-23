require "rails_helper"

RSpec.feature "Group Management" do
  scenario "The owner renames the group, edits rules, draws names and removes someone" do
    owner = create(:user)
    removed_user = create(:user, name: "Bad Actor")
    other_users = create_list(:user, 3)
    group = create(
      :group,
      owner: owner,
      users: [owner, removed_user, *other_users],
      name: "Old Group Name",
      rule_texts: ["Old rule"]
    )
    create(:idea, group:, user: removed_user, idea: "Bad gift")

    sign_in(owner)

    expect(page).to have_text("Old Group Name")
    expect(page).to have_text("Ready when you are")

    fill_in("Group name", with: "New Group Name")
    click_on("Update")

    expect(page).to have_css("h1", text: "New Group Name")
    expect(group.reload.name).to eq("New Group Name")

    within("section[aria-labelledby='rules-heading']") do
      fill_in("Add a rule", with: "Keep it under £20")
      click_on("Add")
    end

    expect(page).to have_text("Keep it under £20")

    click_on("Remove rule: Old rule")

    expect(page).to have_no_text("Old rule")
    expect(group.rules.reload.map(&:text)).to eq(["Keep it under £20"])

    click_on("Draw names")

    expect(page).to have_text("You're buying for")

    pair_ids = group.pairs.pluck(:id)
    expect(pair_ids.count).to eq(5)

    click_on("Draw names again")
    within("dialog[open]") { expect(page).to have_text("Draw names again?") }
    confirm_dialog("Yes, draw again")

    expect(page).to have_text("You're buying for")
    expect(group.pairs.pluck(:id)).not_to eq(pair_ids)

    click_on("Remove Bad Actor from the group")
    confirm_dialog("Yes, remove Bad Actor")

    expect(page).to have_no_text("Bad Actor")
    expect(page).to have_text("Ready when you are")
    expect(group.users).not_to include(removed_user)
    expect(group.ideas.where(user: removed_user)).to be_empty
  end

  scenario "The owner cancels a confirmation" do
    owner = create(:user)
    member = create(:user, name: "Alex")
    group = create(:group, owner:, users: [owner, member])

    sign_in(owner)
    click_on("Remove Alex from the group")
    within("dialog[open]") { click_on("Cancel") }

    expect(page).to have_no_css("dialog[open]")
    expect(group.reload.users).to include(member)
  end

  scenario "The owner resets the group for this year" do
    owner = create(:user)
    member = create(:user)
    other_member = create(:user)
    group = create(:group, owner:, users: [owner, member, other_member], rule_texts: ["Keep it under £20"])
    group.assign_partners
    create(:idea, group:, user: owner, idea: "Socks")
    create(:idea, group:, user: member, idea: "Mug")

    sign_in(owner)

    expect(page).to have_text("You're buying for")

    click_on("Clear everything…")
    # The dialog shows the details from the button's ConfirmationComponent
    within("dialog[open]") do
      expect(page).to have_css("h2", text: "Clear everything?")
      expect(page).to have_css("li", text: "Everyone's gift ideas are deleted")
    end
    confirm_dialog("Yes, clear everything")

    expect(page).to have_text("Ready when you are")
    expect(group.pairs.count).to eq(0)
    expect(group.ideas.count).to eq(0)
    expect(group.users.count).to eq(3)
  end
end
