class AddUniqueIndexToGroupsJoinCode < ActiveRecord::Migration[8.1]
  def change
    add_index :groups, :join_code, unique: true
  end
end
