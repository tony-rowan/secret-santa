# frozen_string_literal: true

module Account
  # Deleting the account, which also deletes every group the user organises (DeleteAccount), so the
  # confirmation names them
  class DeleteComponent < ApplicationComponent
    def initialize(user:, groups:)
      @user = user
      @groups = groups
    end

    private

    attr_reader :user, :groups

    def delete_confirmation
      {
        id: "confirm-delete-account",
        title: "Delete your account?",
        button: "Yes, delete my account",
        icon: :trash,
        removed: [
          "You're removed from every group",
          "All your gift ideas are deleted",
          *owned_groups.map { |group| "#{group.name} is deleted for everyone, because you organise it" }
        ],
        note: "This can't be undone."
      }
    end

    def owned_groups
      groups.select { |group| group.owner?(user) }
    end
  end
end
