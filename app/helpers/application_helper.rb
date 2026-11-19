module ApplicationHelper
  ActionView::Base.default_form_builder = FormBuilders::TailwindFormBuilder

  def icon(name, **)
    render(IconComponent.new(name, **))
  end
end
