# frozen_string_literal: true

module Groups
  # One rule on the create-group form: its text, the hidden input that submits it, and a remove
  # button. Also the template rule_list_controller.js clones for new rules.
  class NewRuleComponent < ApplicationComponent
    def initialize(text:)
      @text = text
    end

    private

    attr_reader :text
  end
end
