# frozen_string_literal: true

module Mailer
  # The "Didn't ask for this?" box at the bottom of an email
  class NotRequestedComponent < ApplicationComponent
    def initialize(message:)
      @message = message
    end

    private

    attr_reader :message
  end
end
