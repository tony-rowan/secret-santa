class DropInviteTokenFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :invite_token
  end
end
