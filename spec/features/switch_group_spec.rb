require "rails_helper"

RSpec.feature "Switch group" do
  scenario "A member of two groups switches between them from the dashboard" do
    user = create(:user)
    rowans = create(:group, name: "Rowans", owner: user)
    create(:group, name: "Book club", users: [user])

    authenticate(user)
    visit(dashboard_path(group_id: rowans.id))
    find("summary[title='Switch group']").click
    click_link("Book club")

    expect(page).to have_css("h1", text: "Book club")
    expect(page).to have_no_css("details[open]")
  end

  scenario "A member closes the switcher with Escape" do
    user = create(:user)
    create(:group, name: "Rowans", owner: user)
    create(:group, name: "Book club", users: [user])

    authenticate(user)
    visit(dashboard_path)
    find("summary[title='Switch group']").click
    expect(page).to have_link("Start a new group")

    find("summary[title='Switch group']").send_keys(:escape)

    expect(page).to have_no_link("Start a new group")
  end
end
