# frozen_string_literal: true

module Dashboard
  # The big card at the top of the dashboard: who you're buying for once names are drawn; until
  # then, the draw for the organiser and the steps so far for everyone else
  class StatusComponent < ApplicationComponent
    def initialize(group:, user:, pair:, idea_counts:)
      @group = group
      @user = user
      @pair = pair
      @idea_counts = idea_counts
    end

    def call
      if pair
        render(MatchComponent.new(pair:, owner: group.owner?(user)))
      elsif group.owner?(user)
        render(DrawComponent.new(group:, idea_counts:))
      else
        render(WaitingComponent.new(has_ideas: idea_counts[user.id].to_i.positive?))
      end
    end

    private

    attr_reader :group, :user, :pair, :idea_counts
  end
end
