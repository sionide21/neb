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

ActiveRecord::Schema.define(version: 20151107143128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pull_requests", force: :cascade do |t|
    t.integer  "repository_id"
    t.integer  "github_id",                  null: false
    t.text     "link"
    t.text     "title"
    t.text     "author"
    t.text     "labels",        default: [],              array: true
    t.text     "state"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "pull_requests", ["github_id"], name: "index_pull_requests_on_github_id", unique: true, using: :btree
  add_index "pull_requests", ["repository_id"], name: "index_pull_requests_on_repository_id", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.integer  "github_id",  null: false
    t.text     "name"
    t.text     "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "repositories", ["github_id"], name: "index_repositories_on_github_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "pull_requests", "repositories"
end
