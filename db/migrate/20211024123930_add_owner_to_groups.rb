class AddOwnerToGroups < ActiveRecord::Migration[6.1]
  def change
    add_reference :groups, :owner, null: false, foreign_key: { to_table: :users }
  end
end
