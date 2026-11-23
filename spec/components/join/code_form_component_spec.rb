require "rails_helper"

RSpec.describe Join::CodeFormComponent, type: :component do
  it "asks for a code or to start a group" do
    render_inline(described_class.new(form: JoinGroup.new, user: create(:user)))

    expect(page).to have_field("Join Code", placeholder: "ABCD-1234")
    expect(page).to have_button("Join group")
    expect(page).to have_link("Start a new group", href: "/groups/new")
  end

  context "when the user is already in a group" do
    it "links back to it" do
      render_inline(described_class.new(form: JoinGroup.new, user: create(:user, :with_group)))

      expect(page).to have_link("Back to your group", href: "/dashboard")
    end
  end

  context "when the user isn't in a group" do
    it "has no way back" do
      render_inline(described_class.new(form: JoinGroup.new, user: create(:user)))

      expect(page).to have_no_link("Back to your group")
    end
  end
end
