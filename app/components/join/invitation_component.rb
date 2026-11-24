# frozen_string_literal: true

module Join
  # An invite link's group, to check before joining: its name and organiser
  class InvitationComponent < ApplicationComponent
    def initialize(group:, form:)
      @group = group
      @form = form
    end

    private

    attr_reader :group, :form
  end
end
