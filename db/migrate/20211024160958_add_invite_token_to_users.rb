class AddInviteTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :invite_token, :string
  end
end
