require "rails_helper"

RSpec.describe Dashboard::MembersComponent, type: :component do
  let(:owner) { create(:user, name: "Olive") }
  let(:member) { create(:user, name: "Alex") }
  let(:group) { create(:group, owner:, users: [owner, member]) }

  context "when the user is the organiser" do
    it "shows a row per member and the invite button" do
      render_inline(described_class.new(group:, user: owner, idea_counts: {}))

      expect(page).to have_css("h2", text: "Members (2)")
      expect(page).to have_css("li.list-row", count: 2)
      expect(page).to have_button("Invite others")
    end

    it "doesn't show the invite token as text" do
      render_inline(described_class.new(group:, user: owner, idea_counts: {}))

      expect(page).to have_no_text(group.invite_token)
    end

    context "when names have been drawn" do
      before { create(:pair, group:, user: owner, other: member) }

      it "says no one new can join instead of offering invites" do
        render_inline(described_class.new(group:, user: owner, idea_counts: {}))

        expect(page).to have_text("Names are drawn, so no one new can join. Reset names to let people join again.")
        expect(page).to have_no_button("Invite others")
      end
    end

    context "when names haven't been drawn" do
      it "doesn't say the group is closed" do
        render_inline(described_class.new(group:, user: owner, idea_counts: {}))

        expect(page).to have_no_text("Names are drawn")
      end
    end

    context "when nobody else has joined" do
      let(:group) { create(:group, owner:, users: [owner]) }

      it "shows the empty state with the invite button instead of a list" do
        render_inline(described_class.new(group:, user: owner, idea_counts: {}))

        expect(page).to have_css("h2", text: "Members (1)")
        expect(page).to have_text("It's just you so far")
        expect(page).to have_text("Send the invite link to everyone you're swapping gifts with. They'll show up here as they join.")
        expect(page).to have_no_css("li.list-row")
        expect(page).to have_button("Invite others", class: "button")
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

      expect(page).to have_no_button("Invite others")
      expect(page).to have_no_css("dialog", visible: :all)
      expect(page).to have_no_css("button", text: /Remove/)
    end
  end
end
