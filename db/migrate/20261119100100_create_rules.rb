# Group rules move from a Markdown text column to one row per rule
class CreateRules < ActiveRecord::Migration[8.1]
  class MigrationGroup < ActiveRecord::Base
    self.table_name = "groups"
  end

  class MigrationRule < ActiveRecord::Base
    self.table_name = "rules"
  end

  LIST_MARKER = /\A\s*(?:[-*+]|\d+[.)]|#+)\s+/
  LINK = /\[([^\]]+)\]\(([^)\s]+)\)/
  EMPHASIS = /\*\*|__|~~|`/

  # Rules are now shown as plain text, so drop the Markdown syntax people are likely to have used
  def self.plain_text(line)
    line.sub(LIST_MARKER, "").gsub(LINK, '\\1 (\\2)').gsub(EMPHASIS, "").squish
  end

  def up
    create_table :rules do |t|
      t.references :group, null: false, foreign_key: true
      t.string :text, null: false
      t.timestamps
    end

    MigrationGroup.where.not(rules: [nil, ""]).find_each do |group|
      group.rules.each_line do |line|
        text = self.class.plain_text(line)
        MigrationRule.create!(group_id: group.id, text:) if text.present?
      end
    end

    remove_column :groups, :rules
  end

  def down
    add_column :groups, :rules, :text

    MigrationGroup.find_each do |group|
      texts = MigrationRule.where(group_id: group.id).order(:id).pluck(:text)
      group.update_columns(rules: texts.map { |text| "- #{text}" }.join("\n")) if texts.any?
    end

    drop_table :rules
  end
end
