# frozen_string_literal: true

# Twinkling dots behind every page
class SnowComponent < ApplicationComponent
  FLAKES = 100

  def flakes
    Array.new(FLAKES) do
      {
        left: rand(1..99),
        top: rand(1..99),
        delay: rand(0.1..0.9),
        duration: rand(1.5..3.5),
        opacity: rand(0..1)
      }
    end
  end
end
