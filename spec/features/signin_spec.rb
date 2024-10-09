require "rails_helper"

RSpec.feature "Sign In" do
  it "allows a user to sign in" do
    FactoryBot.create(:user, :with_group, name: "display name", login: "username", password: "password")

    visit(root_path)
    click_on("Sign In")
    fill_in("Username", with: "username")
    fill_in("Password", with: "password")
    click_on("Sign In")

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("display name")
  end

  it "displays validation errors" do
    visit(root_path)
    click_on("Sign In")
    fill_in("Username", with: "username")
    fill_in("Password", with: "password")
    click_on("Sign In")

    expect(page).to have_text("Unknown email/password combination")
  end
end
