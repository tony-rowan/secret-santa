# frozen_string_literal: true

module Dashboard
  # Who's in the group. The organiser gets the join code, invite buttons and a row per member they
  # can remove; everyone else sees names as chips.
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

    def drawn?
      @_drawn ||= group.pairs.any?
    end
  end
end
