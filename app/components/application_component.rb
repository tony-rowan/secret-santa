# frozen_string_literal: true

# Base for the app's components. Components take everything they show as arguments (the signed-in
# user included, never Current), so each variation can be rendered and specced on its own.
class ApplicationComponent < ViewComponent::Base
  private

  def icon(name, **)
    render(IconComponent.new(name, **))
  end
end
