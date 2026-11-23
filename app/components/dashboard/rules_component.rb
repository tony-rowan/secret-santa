# frozen_string_literal: true

module Dashboard
  # The group's rules. The organiser can add and remove them (so they always get the card); members
  # only see it when there are rules to read.
  class RulesComponent < ApplicationComponent
    def initialize(group:, user:)
      @group = group
      @user = user
    end

    def render?
      owner? || rules.any?
    end

    private

    attr_reader :group, :user

    def rules
      @_rules ||= group.rules.to_a
    end

    def owner?
      group.owner?(user)
    end

    def placeholder
      rules.any? ? "Add a rule…" : "e.g. Keep it under £20"
    end
  end
end
