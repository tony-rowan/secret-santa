class CreateIdeas < ActiveRecord::Migration[6.1]
  def change
    create_table :ideas do |t|
      t.references :user, null: false, foreign_key: true
      t.string :idea, null: false

      t.timestamps
    end
  end
end
