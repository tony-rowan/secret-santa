class GroupPairingsController < ApplicationController
  include GroupOwnerRequired

  def destroy
    group.remove_pairings

    redirect_to edit_group_path(group), success: "Secret santa pairings removed"
  end
end
