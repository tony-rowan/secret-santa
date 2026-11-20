require "rails_helper"

RSpec.describe "Groups" do
  describe "POST /groups" do
    it "creates the group with its rules and shows the created page" do
      user = create(:user)

      authenticate(user)
      post groups_path, params: {group: {name: "The Rowans", rule_texts: ["Keep it under £20", " ", "Swap on Christmas Eve"]}}

      group = Group.last
      expect(group).to have_attributes(name: "The Rowans", owner: user)
      expect(group.rules.map(&:text)).to eq(["Keep it under £20", "Swap on Christmas Eve"])
      expect(response).to redirect_to(created_group_path(group))
    end

    context "when the name is missing" do
      it "re-renders the form keeping the rules" do
        authenticate(create(:user))

        post groups_path, params: {group: {name: "", rule_texts: ["Keep it under £20"]}}

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Please give your group a name", "Keep it under £20")
      end
    end
  end

  describe "GET /groups/:id/created" do
    context "when the user owns the group" do
      it "shows the join code" do
        owner = create(:user)
        group = create(:group, owner:, name: "The Rowans")

        authenticate(owner)
        get created_group_path(group)

        expect(response.body).to include("The Rowans is ready", group.formatted_join_code)
      end
    end

    context "when the user doesn't own the group" do
      it "redirects away" do
        group = create(:group)

        authenticate(create(:user))
        get created_group_path(group)

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
