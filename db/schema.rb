# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_20_213729) do
  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "join_code", null: false
    t.index ["join_code"], name: "index_groups_on_join_code", unique: true
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "ideas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.string "idea", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_ideas_on_group_id"
    t.index ["user_id"], name: "index_ideas_on_user_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "other_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_pairs_on_group_id"
    t.index ["other_id"], name: "index_pairs_on_other_id"
    t.index ["user_id"], name: "index_pairs_on_user_id"
  end

  create_table "rules", force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_rules_on_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_signed_in_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "groups", "users", column: "owner_id"
  add_foreign_key "ideas", "users"
  add_foreign_key "pairs", "groups"
  add_foreign_key "pairs", "users"
  add_foreign_key "pairs", "users", column: "other_id"
  add_foreign_key "rules", "groups"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
end
