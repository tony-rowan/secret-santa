class CreatePairs < ActiveRecord::Migration[6.1]
  def change
    create_table :pairs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :other, null: false, foreign_key: { to_table: :users }
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
