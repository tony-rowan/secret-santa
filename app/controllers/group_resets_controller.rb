class GroupResetsController < ApplicationController
  include GroupOwnerRequired

  def create
    group.reset

    redirect_to dashboard_path, success: "#{group.name} is reset for this year. Gift ideas and drawn names are cleared."
  end
end
