# frozen_string_literal: true

module Join
  # A join link's group, to check before joining: its name, organiser and code
  class InvitationComponent < ApplicationComponent
    def initialize(group:, form:)
      @group = group
      @form = form
    end

    private

    attr_reader :group, :form
  end
end
