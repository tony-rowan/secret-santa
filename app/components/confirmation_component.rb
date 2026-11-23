# frozen_string_literal: true

# What the confirm dialog says before a destructive action: its title and confirm button, plus a
# <template> of details (an icon, what goes, what stays, a warning and a closing note, all optional).
# It wraps the button that asks, which takes its data:
#
#   <%= render ConfirmationComponent.new(id: "confirm-reset", title: "Clear everything?", ...) do |confirmation| %>
#     <%= button_to "Clear everything…", url, data: confirmation.data %>
#   <% end %>
class ConfirmationComponent < ApplicationComponent
  attr_reader :id, :title, :button

  def initialize(id:, title:, button:, icon: nil, removed: [], kept: [], warning: nil, note: nil)
    @id = id
    @title = title
    @button = button
    @icon_name = icon
    @removed = removed.compact
    @kept = kept.compact
    @warning = warning
    @note = note
  end

  # For the button that asks: opens the dialog (see confirm_dialog_controller.js)
  def data
    {
      turbo_confirm: title,
      confirm_button: button,
      confirm_details: id
    }
  end

  private

  attr_reader :icon_name, :removed, :kept, :warning, :note
end
