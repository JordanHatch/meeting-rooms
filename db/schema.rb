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

ActiveRecord::Schema.define(version: 20150427065309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "source_id",                  null: false
    t.integer  "room_id",                    null: false
    t.string   "title"
    t.string   "creator"
    t.datetime "start_at",                   null: false
    t.datetime "end_at",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "private",    default: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "title",               null: false
    t.string   "short_title",         null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "calendar_id"
    t.string   "custom_free_message"
    t.string   "custom_busy_message"
  end

end
