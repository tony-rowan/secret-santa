# frozen_string_literal: true

module Groups
  # Copy the join code, or share a join link (falling back to copying it where sharing isn't
  # supported)
  class InviteButtonsComponent < ApplicationComponent
    def initialize(group:, button_class: nil)
      @group = group
      @button_class = button_class
    end

    private

    attr_reader :group, :button_class

    def join_url
      join_with_code_url(group.formatted_join_code)
    end

    def share_data
      {
        title: "Secret Santa",
        text: "Join my secret santa group!",
        url: join_url
      }.to_json
    end
  end
end
