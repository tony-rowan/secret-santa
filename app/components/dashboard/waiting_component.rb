# frozen_string_literal: true

module Dashboard
  # Names aren't drawn yet, for members: the steps so far, with adding ideas as the current step
  # until they've added one
  class WaitingComponent < ApplicationComponent
    Step = Data.define(:label, :bar, :current)

    def initialize(has_ideas:)
      @has_ideas = has_ideas
    end

    private

    attr_reader :has_ideas

    def steps
      [
        Step.new(label: "Joined", bar: "bg-pine", current: false),
        Step.new(label: "Add ideas", bar: has_ideas ? "bg-pine" : "bg-pine/60", current: !has_ideas),
        Step.new(label: "Names drawn", bar: "bg-pine/25", current: has_ideas)
      ]
    end
  end
end
