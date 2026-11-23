# frozen_string_literal: true

# The parent brand that goes with the Secret Santa name: "by", muddle's blob and its wordmark,
# linking to muddle. Small under the header's name, large on the sign-in page.
class MuddleBylineComponent < ApplicationComponent
  URL = "https://getmuddle.app"

  def initialize(large: false, link_class: nil)
    @large = large
    @link_class = link_class
  end

  private

  attr_reader :large, :link_class

  def link_classes
    [
      "inline-flex items-center font-medium text-lilac-500 hover:text-lilac-300 no-underline",
      large ? "gap-[5px] text-[15px]" : "gap-1 text-[11px]",
      link_class
    ].compact.join(" ")
  end

  def blob_size
    large ? "size-[22px]" : "size-[11px]"
  end

  def wordmark_size
    large ? "text-[22px]" : "text-xs"
  end
end
