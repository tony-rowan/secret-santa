# Accounts are created from a sign-in link before the person has picked a display name
class AllowUsersWithoutAName < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :name, true
  end
end
