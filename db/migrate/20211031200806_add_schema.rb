class AddSchema < ActiveRecord::Migration[6.1]
  def change
    create_table "groups", force: :cascade do |t|
      t.string "name", null: false
      t.bigint "owner_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.text "rules"
      t.string "invite_token"
      t.index ["owner_id"], name: "index_groups_on_owner_id"
    end

    create_table "ideas", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "group_id", null: false
      t.string "idea", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["group_id"], name: "index_ideas_on_group_id"
      t.index ["user_id"], name: "index_ideas_on_user_id"
    end

    create_table "pairs", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "other_id", null: false
      t.bigint "group_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["group_id"], name: "index_pairs_on_group_id"
      t.index ["other_id"], name: "index_pairs_on_other_id"
      t.index ["user_id"], name: "index_pairs_on_user_id"
    end

    create_table "user_groups", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "group_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["group_id"], name: "index_user_groups_on_group_id"
      t.index ["user_id"], name: "index_user_groups_on_user_id"
    end

    create_table "users", force: :cascade do |t|
      t.string "login", null: false
      t.string "password_digest", null: false
      t.string "name", null: false
      t.string "invite_token"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["login"], name: "index_users_on_login", unique: true
    end

    add_foreign_key "groups", "users", column: "owner_id"
    add_foreign_key "ideas", "users"
    add_foreign_key "pairs", "groups"
    add_foreign_key "pairs", "users"
    add_foreign_key "pairs", "users", column: "other_id"
    add_foreign_key "user_groups", "groups"
    add_foreign_key "user_groups", "users"
  end
end
