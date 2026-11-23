# frozen_string_literal: true

module Dashboard
  # Names aren't drawn yet, for the organiser: how many members have added ideas, and the draw
  # (which needs at least 3 people)
  class DrawComponent < ApplicationComponent
    MINIMUM_MEMBERS = 3

    def initialize(group:, idea_counts:)
      @group = group
      @idea_counts = idea_counts
    end

    private

    attr_reader :group, :idea_counts

    def member_count
      @_member_count ||= group.users.count
    end

    def members_with_ideas
      idea_counts.size
    end

    def progress_percent
      member_count.zero? ? 0 : members_with_ideas * 100 / member_count
    end

    def enough_members?
      member_count >= MINIMUM_MEMBERS
    end

    # A group reset after a draw has no pairs, so this only redraws if pairs are somehow left over
    def draw_params
      group.pairs.any? ? {reassign_partners: true} : {assign_partners: true}
    end

    def hint
      if enough_members?
        "Everyone gets one random person. You won't see who has who."
      else
        "You need at least #{MINIMUM_MEMBERS} people to draw names. Invite a few more below."
      end
    end
  end
end
