# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_10_081742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "episodes", id: :serial, force: :cascade do |t|
    t.integer "show_id"
    t.text "episode_url"
    t.text "title"
    t.datetime "insertion_date", default: -> { "now()" }
    t.text "duration", default: "00:00:00"
    t.text "episode_img"
  end

  create_table "shows", force: :cascade do |t|
    t.string "title"
    t.string "small_title"
    t.string "rss_url"
    t.string "show_img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shows_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "show_id", null: false
    t.index ["user_id", "show_id"], name: "index_shows_users_on_user_id_and_show_id"
  end

  create_table "test_models", id: :serial, force: :cascade do |t|
    t.text "test_field"
  end

  create_table "user_episode_joins", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "episode_id"
  end

  create_table "user_show_joins", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "show_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.text "salt"
    t.text "passhash"
    t.text "username"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "user_episode_joins", "episodes", name: "user_episode_joins_episode_id_fkey"
  add_foreign_key "user_episode_joins", "users", name: "user_episode_joins_user_id_fkey"
  add_foreign_key "user_show_joins", "shows", name: "user_show_joins_show_id_fkey"
  add_foreign_key "user_show_joins", "users", name: "user_show_joins_user_id_fkey"
end
