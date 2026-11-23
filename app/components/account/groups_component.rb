# frozen_string_literal: true

module Account
  # The user's groups on the account page, each opening its dashboard, with Leave for the ones they
  # don't organise (the only place members leave a group). With none, ways to get started.
  class GroupsComponent < ApplicationComponent
    def initialize(user:, groups:)
      @user = user
      @groups = groups
    end

    private

    attr_reader :user, :groups
  end
end
