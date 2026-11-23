# frozen_string_literal: true

module Dashboard
  # Renaming the group, for the organiser only. The title is the group switcher, so renaming lives
  # in its own card near the bottom.
  class GroupNameComponent < ApplicationComponent
    def initialize(group:, user:)
      @group = group
      @user = user
    end

    def render?
      group.owner?(user)
    end

    private

    attr_reader :group, :user
  end
end
