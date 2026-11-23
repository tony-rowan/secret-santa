module ComponentHelper
  # The content of a rendered <template> (e.g. a ConfirmationComponent's details). The HTML5 parser
  # Capybara uses keeps a template's content out of the tree, so this reparses the raw output with
  # the HTML4 parser, which treats <template> as an ordinary element.
  def template_content(id)
    template = Nokogiri::HTML4::DocumentFragment.parse(rendered_content).at_css("template##{id}")
    raise ArgumentError, "No <template> with id #{id}" unless template

    Capybara.string(template.inner_html)
  end
end

RSpec.configure do |config|
  config.include(ComponentHelper, type: :component)
end
