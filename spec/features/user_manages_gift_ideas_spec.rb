require "rails_helper"

RSpec.feature "User manages gift ideas" do
  scenario "adding gift ideas" do
    group = create(:group)
    user = create(:user, groups: [group])
    login(user)

    visit(dashboard_path)
    fill_in(:idea_idea, with: "Presents!")
    click_on("Add")
    fill_in(:idea_idea, with: "Food!")
    click_on("Add")

    expect(user.ideas.count).to eq(2)
    expect(page).to have_text("Presents!")
    expect(page).to have_text("Food!")
  end

  scenario "removing gift ideas" do
    group = create(:group)
    user = create(:user, groups: [group])
    create_list(:idea, 2, user: user, group: group)
    login(user)

    visit(dashboard_path)
    click_on("🚮", match: :first)
    click_on("🚮", match: :first)

    expect(user.ideas.count).to eq(0)
  end

  scenario "attempting to add an invalid gift idea" do
    group = create(:group)
    user = create(:user, groups: [group])
    login(user)

    visit(dashboard_path)
    click_on("Add")

    expect(user.ideas.count).to eq(0)
    expect(page).to have_text("Idea can't be blank")

    fill_in(:idea_idea, with: "Presents!")
    click_on("Add")

    expect(user.ideas.count).to eq(1)
    expect(page).to have_text("Presents!")
  end
end
