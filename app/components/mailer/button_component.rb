# frozen_string_literal: true

module Mailer
  # A "bulletproof" email button: the table cell carries the colour, so it still looks like a button
  # where clients drop padding or radius on links
  class ButtonComponent < ApplicationComponent
    def initialize(text:, url:)
      @text = text
      @url = url
    end

    private

    attr_reader :text, :url
  end
end
