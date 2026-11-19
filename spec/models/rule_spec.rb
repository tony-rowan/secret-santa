require "rails_helper"

RSpec.describe Rule do
  it "squishes surrounding and repeated whitespace" do
    rule = create(:group).rules.create!(text: "  Keep   it under £20 \n")

    expect(rule.text).to eq("Keep it under £20")
  end

  context "when the text is blank" do
    it "is invalid" do
      rule = create(:group).rules.build(text: "   ")

      expect(rule).not_to be_valid
    end
  end
end
