# frozen_string_literal: true

require "rails_helper"

# Icon sources must only carry dimensions and drawing instructions. IconComponent owns classes
# and accessibility attributes, so anything of that kind in a source is either stripped at
# render time or, worse, silently depended on.
RSpec.describe "Icon SVG sources" do
  icon_paths = Dir[Rails.root.join("app/assets/images/icons/*.svg")].sort

  it "finds icon sources to check" do
    expect(icon_paths).not_to be_empty
  end

  icon_paths.each do |path|
    describe File.basename(path) do
      it "has no class, role, aria-* or data-* attributes on any element" do
        expect(forbidden_attributes(path)).to be_empty, failure_message(path)
      end

      it "has no title or desc elements" do
        expect(accessible_name_elements(path)).to be_empty,
          "#{File.basename(path)} contains <#{accessible_name_elements(path).join(">, <")}>; accessible names belong to IconComponent"
      end
    end
  end

  private

  def elements(path)
    Oga.parse_xml(File.read(path)).xpath("//*").to_a
  end

  def forbidden_attributes(path)
    elements(path).flat_map do |element|
      element.attributes.map(&:name).grep(/\A(class|role|aria-.*|data-.*)\z/).map { |name| "<#{element.name}> #{name}" }
    end
  end

  def accessible_name_elements(path)
    elements(path).map(&:name) & %w[title desc]
  end

  def failure_message(path)
    "#{File.basename(path)} has attributes that belong to IconComponent: " \
      "#{forbidden_attributes(path).join(", ")}. Remove them from the source."
  end
end
