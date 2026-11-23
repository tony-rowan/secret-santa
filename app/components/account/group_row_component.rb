# frozen_string_literal: true

module Account
  # One of the user's groups on the account page: a link to its dashboard and, unless they organise
  # it, a Leave button that confirms first
  class GroupRowComponent < ApplicationComponent
    def initialize(group:, user:)
      @group = group
      @user = user
    end

    private

    attr_reader :group, :user

    def owner?
      group.owner?(user)
    end

    def organiser_text
      owner? ? "Organised by you" : "Organised by #{group.owner.name}"
    end

    def leave_confirmation
      {
        id: "confirm-leave-#{group.id}",
        title: "Leave #{group.name}?",
        button: "Yes, leave",
        icon: :arrow_right_start_on_rectangle,
        removed: [
          "You leave #{group.name}",
          "Your gift ideas for this group are deleted",
          ("Drawn names are cleared, so they'll need drawing again" if group.pairs.any?)
        ],
        note: "You can join again with the code."
      }
    end
  end
end
