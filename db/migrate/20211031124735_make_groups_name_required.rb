class MakeGroupsNameRequired < ActiveRecord::Migration[6.1]
  def change
    change_column :groups, :name, :name, null: false
  end
end
