# frozen_string_literal: true

module Account
  # The display name card on the account page; saves straight away
  class NameFormComponent < ApplicationComponent
    def initialize(user:)
      @user = user
    end

    private

    attr_reader :user

    def error
      user.errors[:name].first
    end
  end
end
