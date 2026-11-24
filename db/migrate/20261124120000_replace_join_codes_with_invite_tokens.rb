# Join codes were short enough to guess. Invite links carry a long random token instead, and the old
# codes (and any links made from them) stop working.
class ReplaceJoinCodesWithInviteTokens < ActiveRecord::Migration[8.1]
  class MigrationGroup < ActiveRecord::Base
    self.table_name = "groups"
  end

  def up
    add_column :groups, :invite_token, :string

    MigrationGroup.reset_column_information
    MigrationGroup.find_each do |group|
      group.update_columns(invite_token: SecureRandom.base58(24))
    end

    change_column_null :groups, :invite_token, false
    add_index :groups, :invite_token, unique: true

    remove_index :groups, :join_code
    remove_column :groups, :join_code
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
