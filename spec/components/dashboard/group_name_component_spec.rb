require "rails_helper"

RSpec.describe Dashboard::GroupNameComponent, type: :component do
  context "when the user is the organiser" do
    it "offers to rename the group" do
      owner = create(:user)
      group = create(:group, owner:, name: "Elf Squad")

      render_inline(described_class.new(group:, user: owner))

      expect(page).to have_field("Group name", with: "Elf Squad")
      expect(page).to have_button("Update")
    end
  end

  context "when the user is a member" do
    it "renders nothing" do
      member = create(:user)
      group = create(:group, users: [member])

      render_inline(described_class.new(group:, user: member))

      expect(rendered_content).to be_blank
    end
  end
end
