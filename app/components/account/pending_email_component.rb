# frozen_string_literal: true

module Account
  # A requested email change that hasn't been confirmed yet, with ways to resend or cancel it
  class PendingEmailComponent < ApplicationComponent
    def initialize(user:)
      @user = user
    end

    def render?
      user.unconfirmed_email.present?
    end

    private

    attr_reader :user
  end
end
