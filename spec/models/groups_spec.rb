require "rails_helper"

RSpec.describe Group do
  it "sets an invite token on create" do
    group = Group.create!(name: "Group", owner: create(:user))
    expect(group.invite_token).not_to be_nil
  end

  it "doesn't set an invite token if one is already set" do
    group = Group.create!(name: "Group", owner: create(:user), invite_token: "token")
    expect(group.invite_token).to eq("token")
  end
end
