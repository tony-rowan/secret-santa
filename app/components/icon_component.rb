# frozen_string_literal: true

# Icons are hidden from screen readers (aria-hidden) because we don't want them announced.
# Where meaning is needed, the container supplies an accessible label alongside the icon, and
# how it does so is up to the container. An icon given a label carries that meaning itself
# (role="graphics-symbol"), so its container can delegate its name to it.
# https://www.unimelb.edu.au/accessibility/techniques/accessible-svgs
class IconComponent < ViewComponent::Base
  class IconNotFoundError < StandardError; end

  attr_reader :icon, :size, :options

  def initialize(icon, size: "size-6", **options)
    @icon = icon
    @size = size
    @options = options
  end

  def call
    return render_icon_not_found if icon_not_found?

    svg = parsed_svg

    set_classes!(svg)
    set_aria_attributes!(svg, options[:aria])
    set_data_attributes!(svg, options[:data])
    set_base_attributes!(svg, base_attributes)
    set_accessibility_defaults!(svg)

    svg.to_xml.strip.html_safe
  end

  private

  def icon_name
    icon.to_s
  end

  def class_list
    [size, options[:class]].compact_blank.join(" ")
  end

  def base_attributes
    options.except(:class, :aria, :data)
  end

  def set_classes!(svg)
    svg.set("class", (class_list.split + ["icon-#{icon_name.dasherize}"]).join(" "))
  end

  def set_aria_attributes!(svg, aria_attributes)
    aria_attributes&.each do |attribute, value|
      svg.set("aria-#{attribute.to_s.parameterize(preserve_case: true).dasherize}", value.to_s)
    end
  end

  def set_data_attributes!(svg, data_attributes)
    data_attributes&.each do |attribute, value|
      svg.set("data-#{attribute.to_s.parameterize(preserve_case: true).dasherize}", value.to_s)
    end
  end

  def set_base_attributes!(svg, attributes)
    attributes&.each do |attribute, value|
      svg.set(attribute.to_s.parameterize(preserve_case: true).dasherize, value.to_s)
    end
  end

  # Defaults are based on the merged attributes, so explicit caller options always win.
  def set_accessibility_defaults!(svg)
    if svg.get("aria-label").blank?
      svg.set("aria-hidden", "true") if svg.get("aria-hidden").nil?
    elsif svg.get("role").nil?
      svg.set("role", "graphics-symbol")
    end
  end

  def icon_not_found?
    !File.exist?(icon_asset_path)
  end

  def render_icon_not_found
    if Rails.env.local?
      raise IconNotFoundError, "Could not find icon: #{icon_name}"
    else
      "(Icon Not Found)"
    end
  end

  def parsed_svg
    Oga.parse_xml(File.read(icon_asset_path)).at_css("svg")
  end

  def icon_asset_path
    @_icon_asset_path ||= Rails.root.join("app/assets/images/icons/#{icon_name}.svg").to_s
  end
end
