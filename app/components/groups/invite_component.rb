# frozen_string_literal: true

module Groups
  # The "Invite others" button: opens the device's share sheet with the group's invite link, or
  # where there isn't one, a dialog with the link to copy
  class InviteComponent < ApplicationComponent
    def initialize(group:, primary: false, button_class: nil)
      @group = group
      @primary = primary
      @button_class = button_class
    end

    private

    attr_reader :group, :primary, :button_class

    def invite_link
      invite_url(group.invite_token)
    end

    def classes
      [primary ? "button" : "button-secondary", button_class].compact.join(" ")
    end

    def dialog_title_id
      "invite-dialog-title-#{group.id}"
    end

    def share_data
      {
        title: "Secret Santa",
        text: "Join #{group.name} for Secret Santa",
        url: invite_link
      }
    end
  end
end
