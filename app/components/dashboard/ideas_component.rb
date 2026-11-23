# frozen_string_literal: true

module Dashboard
  # The user's own gift ideas for this group, with a form to add more
  class IdeasComponent < ApplicationComponent
    def initialize(ideas:, drawn:, idea: Idea.new)
      @ideas = ideas.to_a
      @drawn = drawn
      @idea = idea
    end

    private

    attr_reader :ideas, :drawn, :idea

    def hint
      drawn ? "Keep adding — your Secret Santa can see these now." : "Only your Secret Santa will see these."
    end

    def placeholder
      ideas.empty? ? "e.g. Fluffy socks" : "Add an idea…"
    end
  end
end
