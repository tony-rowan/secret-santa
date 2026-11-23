# frozen_string_literal: true

module LegalPages
  # Links to the other legal page and back to the app
  class FooterComponent < ApplicationComponent
    def initialize(other_page_text:, other_page_path:)
      @other_page_text = other_page_text
      @other_page_path = other_page_path
    end

    private

    attr_reader :other_page_text, :other_page_path
  end
end
