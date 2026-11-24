# frozen_string_literal: true

module Dashboard
  # "Reset names", for the organiser once names are drawn: clears the pairings so more people can
  # join or names can be drawn again after bad match-ups. Gift ideas, members and rules stay.
  class ResetDrawComponent < ApplicationComponent
    def initialize(group:, user:)
      @group = group
      @user = user
    end

    def render?
      group.owner?(user) && group.pairs.any?
    end

    private

    attr_reader :group, :user

    def reset_draw_confirmation
      {
        id: "confirm-reset-draw",
        title: "Reset names?",
        button: "Yes, reset names",
        icon: :arrow_path,
        removed: ["Drawn names are cleared"],
        kept: ["Everyone's gift ideas stay", "All #{pluralize(group.users.count, "member")} stay in the group", "The rules stay as they are"],
        note: "The invite link works again until you draw names."
      }
    end
  end
end
