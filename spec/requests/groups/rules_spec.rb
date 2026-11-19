require "rails_helper"

RSpec.describe "Group rules" do
  describe "POST /groups/:group_id/rules" do
    context "when the authenticated user is the owner" do
      it "adds the rule" do
        owner = create(:user)
        group = create(:group, owner:)

        authenticate(owner)
        post group_rules_path(group), params: {rule: {text: "Keep it under £20"}}

        expect(group.rules.map(&:text)).to eq(["Keep it under £20"])
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when the rule is blank" do
      it "adds nothing" do
        owner = create(:user)
        group = create(:group, owner:)

        authenticate(owner)
        post group_rules_path(group), params: {rule: {text: " "}}

        expect(group.rules).to be_empty
      end
    end

    context "when the authenticated user is a non-owner member" do
      it "adds nothing" do
        member = create(:user)
        group = create(:group, users: [member])

        authenticate(member)
        post group_rules_path(group), params: {rule: {text: "Anything goes"}}

        expect(group.rules).to be_empty
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "DELETE /groups/:group_id/rules/:id" do
    context "when the authenticated user is the owner" do
      it "removes the rule" do
        owner = create(:user)
        group = create(:group, owner:, rule_texts: ["Keep it under £20"])

        authenticate(owner)
        delete group_rule_path(group, group.rules.first)

        expect(group.rules.reload).to be_empty
      end
    end

    context "when the rule belongs to another group" do
      it "is not found" do
        owner = create(:user)
        group = create(:group, owner:)
        other_rule = create(:group, owner:, rule_texts: ["Not yours"]).rules.first

        authenticate(owner)
        delete group_rule_path(group, other_rule)

        expect(response).to have_http_status(:not_found)
        expect(Rule.exists?(other_rule.id)).to be(true)
      end
    end
  end
end
