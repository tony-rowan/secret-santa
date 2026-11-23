require "rails_helper"

RSpec.describe Groups::NewRuleComponent, type: :component do
  it "shows the rule, submits it and offers to remove it" do
    render_inline(described_class.new(text: "Swap on Christmas Eve"))

    expect(page).to have_css("[data-rule-text]", text: "Swap on Christmas Eve")
    expect(page).to have_css("input[type='hidden'][value='Swap on Christmas Eve']", visible: :all)
    expect(page).to have_button("Remove rule: Swap on Christmas Eve")
  end
end
