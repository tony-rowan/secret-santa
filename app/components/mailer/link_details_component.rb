# frozen_string_literal: true

module Mailer
  # Under an email's button: how long the link works, and the link spelled out for when the button
  # doesn't
  class LinkDetailsComponent < ApplicationComponent
    def initialize(expiry:, url:)
      @expiry = expiry
      @url = url
    end

    private

    attr_reader :expiry, :url
  end
end
