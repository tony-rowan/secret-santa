class AddJoinCodeToGroups < ActiveRecord::Migration[7.2]
  def change
    add_column :groups, :join_code, :string, null: false, default: "N/A"
  end
end
