# frozen_string_literal: true

# The gift icon, "Secret Santa" and "by muddle" beneath it, for the header and the legal pages. The
# name links to path and its hit area stretches over the whole lockup (so the icon works too); the
# byline is its own link to muddle, layered above, since links can't nest.
class BrandLockupComponent < ApplicationComponent
  SIZES = {
    header: {
      icon: "size-7 lg:size-[30px]",
      text: "text-xl lg:text-2xl",
      lockup: "gap-2.5 lg:gap-3"
    },
    document: {
      icon: "size-6",
      text: "text-xl",
      lockup: "self-start gap-2.5 min-h-11"
    }
  }.freeze

  def initialize(path:, size: :header)
    @path = path
    @size = SIZES.fetch(size)
  end

  private

  attr_reader :path, :size
end
