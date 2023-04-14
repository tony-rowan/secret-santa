class RemoveInviteTokenFromGroups < ActiveRecord::Migration[7.0]
  def change
    remove_column :groups, :invite_token
  end
end
