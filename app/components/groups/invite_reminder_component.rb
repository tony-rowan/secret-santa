# frozen_string_literal: true

module Groups
  # Under the start-a-group form for people with no groups yet: someone who expected to join a group
  # has landed here without their invite, so point them back to its link
  class InviteReminderComponent < ApplicationComponent
    def initialize(user:)
      @user = user
    end

    def render?
      user.groups.none?
    end

    private

    attr_reader :user
  end
end
