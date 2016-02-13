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

ActiveRecord::Schema.define(version: 20160212055449) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_dates", force: :cascade do |t|
    t.integer  "event_id",   null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_dates", ["event_id"], name: "index_event_dates_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title",       null: false
    t.text     "description"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "events", ["location_id"], name: "index_events_on_location_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "person_id"
    t.boolean  "admin",      default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "participations", ["person_id"], name: "index_participations_on_person_id", using: :btree
  add_index "participations", ["project_id"], name: "index_participations_on_project_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree

  create_table "project_tags", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "tag_id",     null: false
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "project_tags", ["project_id"], name: "index_project_tags_on_project_id", using: :btree
  add_index "project_tags", ["tag_id"], name: "index_project_tags_on_tag_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "scm_urls",    default: [],              array: true
    t.string   "icon"
    t.string   "tagline"
  end

  create_table "role_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_offers", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "role_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "role_offers", ["person_id"], name: "index_role_offers_on_person_id", using: :btree
  add_index "role_offers", ["role_id"], name: "index_role_offers_on_role_id", using: :btree

  create_table "role_requests", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "role_id"
    t.integer  "priority"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "role_requests", ["project_id"], name: "index_role_requests_on_project_id", using: :btree
  add_index "role_requests", ["role_id"], name: "index_role_requests_on_role_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "skill_name"
    t.string   "person_name"
    t.text     "responsibilities"
    t.integer  "category_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "roles", ["category_id"], name: "index_roles_on_category_id", using: :btree

  create_table "tag_categories", force: :cascade do |t|
    t.string   "key",        null: false
    t.string   "name",       null: false
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",        null: false
    t.integer  "category_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "long_name"
  end

  add_index "tags", ["category_id"], name: "index_tags_on_category_id", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  add_foreign_key "event_dates", "events"
  add_foreign_key "events", "locations"
  add_foreign_key "participations", "people"
  add_foreign_key "participations", "projects"
  add_foreign_key "project_tags", "projects"
  add_foreign_key "project_tags", "tags"
  add_foreign_key "role_offers", "people"
  add_foreign_key "role_offers", "roles"
  add_foreign_key "role_requests", "projects"
  add_foreign_key "role_requests", "roles"
  add_foreign_key "roles", "role_categories", column: "category_id"
  add_foreign_key "tags", "tag_categories", column: "category_id"
end
