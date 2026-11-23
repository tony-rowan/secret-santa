# frozen_string_literal: true

module Dashboard
  # One member in the organiser's list: their name, who they are and how many ideas they've added,
  # and (for everyone but the organiser) a Remove button that confirms first
  class MemberRowComponent < ApplicationComponent
    def initialize(group:, member:, user:, idea_count:, drawn:)
      @group = group
      @member = member
      @user = user
      @idea_count = idea_count
      @drawn = drawn
    end

    private

    attr_reader :group, :member, :user, :idea_count, :drawn

    def details
      [
        ("You" if member == user),
        ("organiser" if group.owner?(member)),
        idea_count.zero? ? "No ideas yet" : pluralize(idea_count, "idea")
      ].compact.join(" · ")
    end

    # Members without ideas are flagged in gold so the organiser can nudge them
    def details_class
      idea_count.zero? ? "text-gold" : "text-lilac-400"
    end

    def removable?
      !group.owner?(member)
    end

    def remove_label
      "Remove #{member.name} from the group"
    end

    def remove_confirmation
      {
        id: "confirm-remove-#{member.id}",
        title: "Remove #{member.name}?",
        button: "Yes, remove #{member.name}",
        icon: :user_minus,
        removed: ["#{member.name} leaves the group", "#{member.name}'s gift ideas are deleted"],
        warning: ("Names have already been drawn. Removing #{member.name} clears them, so you'll need to draw again." if drawn)
      }
    end
  end
end
