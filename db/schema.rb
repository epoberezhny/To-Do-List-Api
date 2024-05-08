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

ActiveRecord::Schema[7.1].define(version: 2024_05_06_214822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "text"
    t.bigint "task_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "attachment_data"
    t.index ["task_id"], name: "index_comments_on_task_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "name"], name: "index_projects_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.bigint "project_id"
    t.boolean "done", default: false, null: false
    t.integer "priority"
    t.datetime "deadline", precision: nil
    t.integer "comments_count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "user_active_session_keys", primary_key: ["user_id", "session_id"], force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "session_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "last_use", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["user_id"], name: "index_user_active_session_keys_on_user_id"
  end

  create_table "user_jwt_refresh_keys", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.index ["user_id"], name: "index_user_jwt_refresh_keys_on_user_id"
    t.index ["user_id"], name: "user_jwt_rk_user_id_idx"
  end

  create_table "users", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.citext "email", null: false
    t.string "password_hash"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(status = ANY (ARRAY[1, 2]))"
  end

  add_foreign_key "comments", "tasks"
  add_foreign_key "projects", "users"
  add_foreign_key "tasks", "projects"
  add_foreign_key "user_active_session_keys", "users"
  add_foreign_key "user_jwt_refresh_keys", "users"
end
