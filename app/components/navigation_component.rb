# frozen_string_literal: true

# The header on the dashboard and account pages: the brand (home to the dashboard) and, when signed
# in, the Account button. Same size on every page, whatever the width of the content below it.
class NavigationComponent < ApplicationComponent
  def initialize(user:)
    @user = user
  end

  private

  attr_reader :user
end
