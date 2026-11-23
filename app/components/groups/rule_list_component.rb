# frozen_string_literal: true

module Groups
  # The rules card on the create-group form. The list is built client-side (rule_list_controller.js)
  # from a template row, before the group exists, and submitted as group[rule_texts][].
  class RuleListComponent < ApplicationComponent
    def initialize(rules:)
      @rules = rules.to_a
    end

    private

    attr_reader :rules
  end
end
