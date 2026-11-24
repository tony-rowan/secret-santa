# "Reset the draw" on the dashboard: clears the pairings only, so the group takes new members again
class GroupDrawResetsController < ApplicationController
  include GroupOwnerRequired

  def create
    group.reset_draw

    redirect_to dashboard_path
  end
end
