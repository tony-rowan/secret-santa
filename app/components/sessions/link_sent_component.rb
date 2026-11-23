# frozen_string_literal: true

module Sessions
  # What the "check your email" page says was sent, and to join which group when there's an invite
  class LinkSentComponent < ApplicationComponent
    def initialize(email:, group: nil)
      @email = email
      @group = group
    end

    private

    attr_reader :email, :group
  end
end
