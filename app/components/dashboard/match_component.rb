# frozen_string_literal: true

module Dashboard
  # Names are drawn: who you're buying for and their gift ideas, and for the organiser, a redraw
  class MatchComponent < ApplicationComponent
    def initialize(pair:, owner:)
      @pair = pair
      @owner = owner
    end

    private

    attr_reader :pair, :owner

    def match
      pair.other
    end

    def match_ideas
      @_match_ideas ||= match.ideas.where(group: pair.group).to_a
    end

    def redraw_confirmation
      {
        id: "confirm-redraw",
        title: "Draw names again?",
        button: "Yes, draw again",
        icon: :arrow_path,
        removed: ["Everyone gets a new person, including you", "Anyone who has started shopping may need to start again"],
        kept: ["Gift ideas stay as they are"]
      }
    end
  end
end
