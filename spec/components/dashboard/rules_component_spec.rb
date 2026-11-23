require "rails_helper"

RSpec.describe Dashboard::RulesComponent, type: :component do
  let(:owner) { create(:user) }
  let(:member) { create(:user) }

  context "when the user is the organiser" do
    it "lists the rules with remove buttons and a form to add more" do
      group = create(:group, owner:, rule_texts: ["Keep it under £20"])

      render_inline(described_class.new(group:, user: owner))

      expect(page).to have_text("Everyone in the group sees these.")
      expect(page).to have_css("li", text: "Keep it under £20")
      expect(page).to have_button("Remove rule: Keep it under £20")
      expect(page).to have_field("Add a rule", placeholder: "Add a rule…")
    end

    context "when there are no rules" do
      it "still renders, suggesting one" do
        group = create(:group, owner:)

        render_inline(described_class.new(group:, user: owner))

        expect(page).to have_field("Add a rule", placeholder: "e.g. Keep it under £20")
        expect(page).to have_no_css("li")
      end
    end
  end

  context "when the user is a member" do
    it "lists the rules without tools" do
      group = create(:group, users: [member], rule_texts: ["No spending over $20"])

      render_inline(described_class.new(group:, user: member))

      expect(page).to have_css("li", text: "No spending over $20")
      expect(page).to have_no_css("button", text: /Remove rule/)
      expect(page).to have_no_field("Add a rule")
      expect(page).to have_no_text("Everyone in the group sees these.")
    end

    context "when there are no rules" do
      it "renders nothing" do
        group = create(:group, users: [member])

        render_inline(described_class.new(group:, user: member))

        expect(rendered_content).to be_blank
      end
    end
  end
end
