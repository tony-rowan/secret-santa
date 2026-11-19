require "rails_helper"

RSpec.describe "GET /dashboard" do
  context "when signed in" do
    it "links to the account page from the header" do
      user = create(:user)

      authenticate(user)
      get dashboard_path

      expect(response.body).to include(%(href="#{edit_user_path(user)}"))
    end
  end

  context "when the user owns the group" do
    it "shows the group name, invite code and organiser actions" do
      owner = create(:user)
      group = create(:group, owner:, name: "Elf Squad", users: [owner, *create_list(:user, 2)])

      authenticate(owner)
      get dashboard_path
      page = Capybara.string(response.body)

      expect(page).to have_css("h1", text: "Elf Squad")
      expect(page).to have_css(".join-code", text: group.join_code)
      expect(page).to have_button("Copy code")
      expect(page).to have_link("Share link", href: join_with_code_url(group.join_code))
      expect(page).to have_link("Rename group", href: edit_group_path(group))
      expect(page).to have_button("Clear everything…")
      expect(page).to have_button("Draw names")
      expect(page).to have_no_button("Leave this group")
    end
  end

  context "when the group has fewer than 3 members" do
    it "disables the draw and explains why" do
      owner = create(:user)
      create(:group, owner:, users: [owner, create(:user)])

      authenticate(owner)
      get dashboard_path
      page = Capybara.string(response.body)

      expect(page).to have_button("Draw names", disabled: true)
      expect(page).to have_text("You need at least 3 people to draw names")
    end
  end

  context "when the user is a member but not the owner" do
    it "shows only the leave action" do
      group = create(:group, name: "Elf Squad")
      member = create(:user)
      group.users << member

      authenticate(member)
      get dashboard_path
      page = Capybara.string(response.body)

      expect(page).to have_button("Leave this group")
      expect(page).to have_text("Waiting for the draw")
      expect(page).to have_no_link("Rename group")
      expect(page).to have_no_css(".join-code")
      expect(page).to have_no_button("Draw names")
    end
  end

  context "when names have been drawn" do
    it "shows who the user is buying for and their ideas" do
      owner = create(:user)
      match = create(:user, name: "Alex")
      group = create(:group, owner:, users: [owner, match, create(:user)])
      create(:pair, group:, user: owner, other: match)
      create(:idea, group:, user: match, idea: "Anything chocolate")

      authenticate(owner)
      get dashboard_path
      page = Capybara.string(response.body)

      expect(page).to have_text("You're buying for")
      expect(page).to have_css("h2", text: "Alex")
      expect(page).to have_css("li", text: "Anything chocolate")
      expect(page).to have_button("Draw names again")
    end
  end

  context "when the user has no gift ideas" do
    it "shows the empty state" do
      owner = create(:user)
      create(:group, owner:)

      authenticate(owner)
      get dashboard_path

      expect(Capybara.string(response.body)).to have_text("No ideas yet")
    end
  end

  context "when the group has no rules and the user is a member" do
    it "does not render the Rules box" do
      member = create(:user)
      create(:group, users: [member])

      authenticate(member)
      get dashboard_path

      expect(Capybara.string(response.body)).to have_no_css("h2", text: "Rules")
    end
  end

  context "when the group has no rules and the user is the owner" do
    it "renders the Rules box so they can add some" do
      owner = create(:user)
      create(:group, owner:)

      authenticate(owner)
      get dashboard_path

      expect(Capybara.string(response.body)).to have_field("Add a rule")
    end
  end

  context "when the group has rules" do
    it "lists them" do
      member = create(:user)
      create(:group, users: [member], rule_texts: ["No spending over $20"])

      authenticate(member)
      get dashboard_path
      rules = Capybara.string(response.body).find("section[aria-labelledby='rules-heading']")

      expect(rules).to have_css("li", text: "No spending over $20")
    end
  end

  context "when the user has no display name yet" do
    it "asks for one first" do
      authenticate(create(:user, name: nil))

      get dashboard_path

      expect(response).to redirect_to(new_display_name_path)
    end
  end

  context "when a group is chosen" do
    it "shows that group from then on" do
      user = create(:user)
      first = create(:group, name: "Book club", users: [user])
      create(:group, name: "Rowans", owner: user)

      authenticate(user)
      get dashboard_path(group_id: first.id)
      expect(response.body).to include("Book club")

      get dashboard_path
      expect(response.body).to include("Book club")
    end
  end

  context "when the chosen group isn't one of the user's" do
    it "ignores it" do
      user = create(:user)
      create(:group, name: "Rowans", owner: user)
      other = create(:group, name: "Strangers")

      authenticate(user)
      get dashboard_path(group_id: other.id)

      expect(response.body).to include("Rowans")
      expect(response.body).not_to include("Strangers")
    end
  end
end
