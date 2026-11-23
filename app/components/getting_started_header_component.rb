# frozen_string_literal: true

# The top of every getting-started page: an icon tile, the title and a subtitle. The untitled page
# (sign in) is the brand's front door, so it shows "Secret Santa" and says who makes it, and glows.
class GettingStartedHeaderComponent < ApplicationComponent
  def initialize(icon: nil, title: nil, subtitle: nil, glow: false)
    @icon_name = icon.presence || :gift
    @title = title.presence
    @subtitle = subtitle.presence
    @glow = glow
  end

  private

  attr_reader :icon_name, :title, :subtitle, :glow

  def tile_classes
    [
      "size-22 shrink-0 rounded-[28px] bg-night-800 border-[1.5px] border-gold text-gold flex items-center justify-center",
      ("ring-8 ring-gold/12" if glow)
    ].compact.join(" ")
  end

  def title_classes
    [
      "font-display font-bold break-words max-w-full",
      glow ? "text-[40px] tracking-tight leading-none" : "text-[34px] leading-tight"
    ].join(" ")
  end
end
