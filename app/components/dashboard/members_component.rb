# frozen_string_literal: true

module Dashboard
  # Who's in the group. The organiser gets a row per member they can remove and the invite button
  # (until names are drawn, when the group stops taking new members), or an empty state while it's
  # just them; everyone else sees names as chips.
  class MembersComponent < ApplicationComponent
    def initialize(group:, user:, idea_counts:)
      @group = group
      @user = user
      @idea_counts = idea_counts
    end

    private

    attr_reader :group, :user, :idea_counts

    def members
      @_members ||= group.users.to_a
    end

    def owner?
      group.owner?(user)
    end

    def just_the_organiser?
      members == [user]
    end

    def drawn?
      @_drawn ||= group.pairs.any?
    end
  end
end
