class RenameUsersLoginToEmail < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :login, :email
  end
end
