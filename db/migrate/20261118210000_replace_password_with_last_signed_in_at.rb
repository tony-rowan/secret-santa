class ReplacePasswordWithLastSignedInAt < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :password_digest, :string, null: false
    add_column :users, :last_signed_in_at, :datetime
  end
end
