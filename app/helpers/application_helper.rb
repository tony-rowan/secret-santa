module ApplicationHelper
  ActionView::Base.default_form_builder = FormBuilders::TailwindFormBuilder

  def icon(name, **)
    render(IconComponent.new(name, **))
  end

  MARKDOWN_OPTIONS = {
    extension: {autolink: true, strikethrough: true, table: true, header_ids: nil},
    render: {unsafe: false}
  }.freeze
  MARKDOWN_TAGS = (Rails::HTML5::SafeListSanitizer.allowed_tags + %w[table thead tbody tr th td]).freeze

  # Renders user-written Markdown. Raw HTML is disabled in Commonmarker and the
  # output is sanitised again as defence in depth (this is a stored-XSS boundary).
  def markdown(text)
    return "".html_safe if text.blank?

    html = Commonmarker.to_html(text, options: MARKDOWN_OPTIONS)
    sanitize(html, tags: MARKDOWN_TAGS)
  end
end
