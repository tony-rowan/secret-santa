class AddRulesToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :rules, :text
  end
end
