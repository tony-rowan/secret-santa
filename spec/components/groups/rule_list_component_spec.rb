require "rails_helper"

RSpec.describe Groups::RuleListComponent, type: :component do
  it "lists rules already added, each submitted with the form" do
    rules = [Rule.new(text: "Keep it under £20")]

    render_inline(described_class.new(rules:))

    list = page.find("ul[data-rule-list-target='list']")
    expect(list).to have_css("li", text: "Keep it under £20")
    expect(list).to have_css("input[type='hidden'][name='group[rule_texts][]'][value='Keep it under £20']", visible: :all)
    expect(page).to have_field("Add a rule")
  end

  it "has a blank row for the controller to copy" do
    render_inline(described_class.new(rules: []))

    expect(template_content_of_target).to have_button("Remove rule: ")
  end

  def template_content_of_target
    template = Nokogiri::HTML4::DocumentFragment.parse(rendered_content).at_css("template[data-rule-list-target='template']")
    Capybara.string(template.inner_html)
  end
end
