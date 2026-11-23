# frozen_string_literal: true

module Sessions
  # The sign-in form: one email field (with any error in its label) that signs in or signs up
  class EmailFormComponent < ApplicationComponent
    def initialize(email: nil, error: nil)
      @email = email
      @error = error
    end

    private

    attr_reader :email, :error
  end
end
