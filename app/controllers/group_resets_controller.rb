class GroupResetsController < ApplicationController
  include GroupOwnerRequired

  def create
    group.reset

    redirect_to dashboard_path
  end
end
