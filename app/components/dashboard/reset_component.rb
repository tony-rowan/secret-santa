# frozen_string_literal: true

module Dashboard
  # "Reset for this year", for the organiser only: clears ideas and the draw, keeps members and rules
  class ResetComponent < ApplicationComponent
    def initialize(group:, user:)
      @group = group
      @user = user
    end

    def render?
      group.owner?(user)
    end

    private

    attr_reader :group, :user

    def reset_confirmation
      {
        id: "confirm-reset",
        title: "Clear everything?",
        button: "Yes, clear everything",
        icon: :arrow_path,
        removed: ["Everyone's gift ideas are deleted", "Drawn names are cleared"],
        kept: ["All #{pluralize(group.users.count, "member")} stay in the group", "The rules stay as they are"],
        note: "This can't be undone."
      }
    end
  end
end
