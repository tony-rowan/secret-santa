# frozen_string_literal: true

module Join
  # Entering a join code by hand, or starting a group instead. People already in a group can go
  # back to it.
  class CodeFormComponent < ApplicationComponent
    def initialize(form:, user:)
      @form = form
      @user = user
    end

    private

    attr_reader :form, :user

    def in_a_group?
      user.groups.any?
    end
  end
end
