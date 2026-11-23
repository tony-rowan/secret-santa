# frozen_string_literal: true

module Dashboard
  # The group name at the top of the dashboard. For people in more than one group it doubles as a
  # menu to switch between them (a <details> closed by menu_controller.js).
  class GroupTitleComponent < ApplicationComponent
    def initialize(group:, groups:, user:)
      @group = group
      @groups = groups
      @user = user
    end

    private

    attr_reader :group, :groups, :user

    def switcher?
      groups.many?
    end

    def organiser_text(other)
      other.owner?(user) ? "Organised by you" : "Organised by #{other.owner.name}"
    end
  end
end
