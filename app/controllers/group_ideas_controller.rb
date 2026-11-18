class GroupIdeasController < ApplicationController
  include GroupOwnerRequired

  def destroy
    group.remove_ideas

    redirect_to edit_group_path(group), success: "Gift ideas removed"
  end
end
