# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160916153542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competition_teams", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "checked_in",     default: false
  end

  add_index "competition_teams", ["competition_id"], name: "index_competition_teams_on_competition_id", using: :btree
  add_index "competition_teams", ["team_id"], name: "index_competition_teams_on_team_id", using: :btree

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.string   "admin_name"
    t.string   "admin_mobile"
    t.boolean  "started",      default: false
    t.datetime "start_time"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "team_size"
    t.text     "description"
    t.string   "admin_email"
  end

  create_table "file_competitions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "admin_name"
    t.datetime "deadline"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "admin_email"
  end

  create_table "file_results", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "comment"
    t.integer  "score"
    t.text     "admin_comment"
    t.integer  "file_competition_id"
    t.string   "contribution_file_name"
    t.string   "contribution_content_type"
    t.integer  "contribution_file_size"
    t.datetime "contribution_updated_at"
  end

  create_table "images", force: :cascade do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "main_menu",  default: false
    t.boolean  "front_page", default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "position"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.integer  "team1_score"
    t.integer  "team2_score"
    t.integer  "competition_id"
    t.integer  "round"
    t.integer  "match"
    t.boolean  "lower_bracket",  default: false
    t.integer  "user_id"
    t.boolean  "validated",      default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "screenshots", force: :cascade do |t|
    t.integer  "result_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "team_seeds", force: :cascade do |t|
    t.string   "team_name"
    t.integer  "competition_id"
    t.integer  "seed"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_teams", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_teams", ["team_id"], name: "index_user_teams_on_team_id", using: :btree
  add_index "user_teams", ["user_id"], name: "index_user_teams_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "last_seen"
  end

end
