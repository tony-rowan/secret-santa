require "rails_helper"

RSpec.feature "Change email" do
  scenario "A user changes their email by confirming from the new address" do
    user = create(:user, email: "old@example.com")

    authenticate(user)
    visit(edit_user_path(user))
    fill_in("New email address", with: "new@example.com")
    click_on("Send verification link")

    expect(page).to have_current_path(edit_user_path(user))
    expect(page).to have_text("We've sent a confirmation link to new@example.com")
    expect(page).to have_text("Waiting for you to verify new@example.com")
    expect(user.reload.email).to eq("old@example.com")

    visit(URI(last_email_confirmation_url).request_uri)

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_text("Email updated")

    click_on("Account")
    click_on("Sign out")
    ActionMailer::Base.deliveries.clear
    sign_in(user.reload)

    expect(page).to have_current_path(dashboard_path)
    expect(user.email).to eq("new@example.com")
  end

  scenario "A user cancels a pending change" do
    user = create(:user, unconfirmed_email: "new@example.com")

    authenticate(user)
    visit(edit_user_path(user))
    click_on("Cancel change")

    expect(page).to have_text("Email change cancelled")
    expect(page).not_to have_text("Waiting for you to verify")
  end

  scenario "A user resends the verification link" do
    user = create(:user, unconfirmed_email: "new@example.com")

    authenticate(user)
    visit(edit_user_path(user))
    click_on("Resend")

    expect(page).to have_text("We've sent another link to new@example.com")
    expect(ActionMailer::Base.deliveries.last.to).to eq(["new@example.com"])
  end
end
