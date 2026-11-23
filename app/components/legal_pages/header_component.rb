# frozen_string_literal: true

module LegalPages
  # The privacy policy's or terms' title, when they last changed, and the short version
  class HeaderComponent < ApplicationComponent
    LAST_UPDATED = "20 November 2026"

    def initialize(title:, summary:)
      @title = title
      @summary = summary
    end

    private

    attr_reader :title, :summary
  end
end
