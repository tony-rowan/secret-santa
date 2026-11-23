# frozen_string_literal: true

module Account
  # The email card on the account page. A new address is only applied once confirmed from it, so
  # this also shows any change still waiting for that.
  class EmailFormComponent < ApplicationComponent
    def initialize(user:, new_email: nil)
      @user = user
      @new_email = new_email
    end

    private

    attr_reader :user, :new_email

    def error
      user.errors[:email].first
    end
  end
end
