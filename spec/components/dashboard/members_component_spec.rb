require "rails_helper"

RSpec.describe Dashboard::MembersComponent, type: :component do
  let(:owner) { create(:user, name: "Olive") }
  let(:member) { create(:user, name: "Alex") }
  let(:group) { create(:group, owner:, users: [owner, member]) }

  context "when the user is the organiser" do
    it "shows the join code, invite buttons and a row per member" do
      render_inline(described_class.new(group:, user: owner, idea_counts: {}))

      expect(page).to have_css("h2", text: "Members (2)")
      expect(page).to have_css(".join-code", text: group.formatted_join_code)
      expect(page).to have_button("Copy code")
      expect(page).to have_css("li.list-row", count: 2)
    end

    context "when names have been drawn" do
      it "warns that changing members means drawing again" do
        create(:pair, group:, user: owner, other: member)

        render_inline(described_class.new(group:, user: owner, idea_counts: {}))

        expect(page).to have_text("Adding or removing people now means names will need drawing again.")
      end
    end

    context "when names haven't been drawn" do
      it "doesn't warn" do
        render_inline(described_class.new(group:, user: owner, idea_counts: {}))

        expect(page).to have_no_text("need drawing again")
      end
    end
  end

  context "when the user is a member" do
    it "lists names as chips, marking the user and the organiser" do
      render_inline(described_class.new(group:, user: member, idea_counts: {}))

      expect(page).to have_css("h2", text: "Who's in (2)")
      expect(page).to have_css("li", text: "Alex (you)")
      expect(page).to have_css("li", text: "Olive · organiser")
    end

    it "shows no organiser tools" do
      render_inline(described_class.new(group:, user: member, idea_counts: {}))

      expect(page).to have_no_css(".join-code")
      expect(page).to have_no_button("Copy code")
      expect(page).to have_no_css("button", text: /Remove/)
    end
  end
end
