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

ActiveRecord::Schema.define(version: 20161030061304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fitbit_users", force: :cascade do |t|
    t.string   "remote_id",                   null: false
    t.string   "display_name",                null: false
    t.string   "full_name"
    t.jsonb    "avatars",      default: "{}", null: false
    t.string   "timezone",                    null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["remote_id"], name: "index_fitbit_users_on_remote_id", unique: true, using: :btree
  end

end
