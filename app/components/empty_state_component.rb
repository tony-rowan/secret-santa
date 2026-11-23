# frozen_string_literal: true

# The dashed box shown in place of an empty list: an illustration (the content), a title and a line
# of text
class EmptyStateComponent < ApplicationComponent
  def initialize(title:, text:, padding: "px-4 py-6")
    @title = title
    @text = text
    @padding = padding
  end

  private

  attr_reader :title, :text, :padding
end
