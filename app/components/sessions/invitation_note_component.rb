# frozen_string_literal: true

module Sessions
  # On the sign-in page after following a join link: who invited you to what
  class InvitationNoteComponent < ApplicationComponent
    def initialize(group:)
      @group = group
    end

    def render?
      group.present?
    end

    private

    attr_reader :group
  end
end
