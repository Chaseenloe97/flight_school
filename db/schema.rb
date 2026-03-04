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

ActiveRecord::Schema[8.1].define(version: 2026_03_04_021010) do
  create_table "aircrafts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "flight_school_id", null: false
    t.string "model"
    t.text "notes"
    t.string "status"
    t.string "tail_number"
    t.datetime "updated_at", null: false
    t.index ["flight_school_id"], name: "index_aircrafts_on_flight_school_id"
    t.index ["tail_number"], name: "index_aircrafts_on_tail_number"
  end

  create_table "downtime_events", force: :cascade do |t|
    t.integer "aircraft_id", null: false
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.text "description"
    t.datetime "ended_at"
    t.string "reason_type"
    t.datetime "started_at"
    t.datetime "updated_at", null: false
    t.index ["aircraft_id"], name: "index_downtime_events_on_aircraft_id"
    t.index ["created_by_id"], name: "index_downtime_events_on_created_by_id"
  end

  create_table "flight_schools", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_flight_schools_on_user_id"
  end

  create_table "maintenance_logs", force: :cascade do |t|
    t.integer "aircraft_id", null: false
    t.datetime "created_at", null: false
    t.decimal "hobbs_hours"
    t.string "log_type"
    t.datetime "logged_at"
    t.text "notes"
    t.decimal "tach_hours"
    t.datetime "updated_at", null: false
    t.index ["aircraft_id"], name: "index_maintenance_logs_on_aircraft_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "aircrafts", "flight_schools"
  add_foreign_key "downtime_events", "aircrafts"
  add_foreign_key "flight_schools", "users"
  add_foreign_key "maintenance_logs", "aircrafts"
end
