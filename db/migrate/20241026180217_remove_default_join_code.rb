class RemoveDefaultJoinCode < ActiveRecord::Migration[7.2]
  def change
    change_column_default :groups, :join_code, nil
  end
end
