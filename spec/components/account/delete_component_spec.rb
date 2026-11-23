require "rails_helper"

RSpec.describe Account::DeleteComponent, type: :component do
  it "confirms before deleting the account" do
    user = create(:user)

    render_inline(described_class.new(user:, groups: []))

    expect(page).to have_css("button[data-turbo-confirm='Delete your account?'][data-confirm-button='Yes, delete my account']", text: "Delete my account…")
    details = template_content("confirm-delete-account")
    expect(details).to have_text("You're removed from every group")
    expect(details).to have_text("All your gift ideas are deleted")
  end

  context "when the user organises groups" do
    it "warns that those groups are deleted for everyone" do
      user = create(:user)
      rowans = create(:group, name: "Rowans", owner: user)
      book_club = create(:group, name: "Book club", users: [user])

      render_inline(described_class.new(user:, groups: [book_club, rowans]))

      details = template_content("confirm-delete-account")
      expect(details).to have_text("Rowans is deleted for everyone, because you organise it")
      expect(details).to have_no_text("Book club is deleted")
    end
  end
end
