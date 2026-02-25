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

ActiveRecord::Schema[8.0].define(version: 2026_02_23_000100) do
  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "full_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "location"
    t.date "event_date"
    t.time "start_time"
    t.time "end_time"
    t.integer "required_volunteer_count"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_assigned_volunteer_count", default: 0, null: false
  end

  create_table "volunteer_assignments", force: :cascade do |t|
    t.integer "volunteer_id", null: false
    t.integer "event_id", null: false
    t.integer "status"
    t.float "hours_worked"
    t.datetime "date_logged"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_volunteer_assignments_on_event_id"
    t.index ["volunteer_id"], name: "index_volunteer_assignments_on_volunteer_id"
  end

  create_table "volunteers", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "full_name"
    t.string "email"
    t.integer "phone_number"
    t.string "address"
    t.text "skills"
    t.text "interests"
    t.float "total_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "volunteer_assignments", "events"
  add_foreign_key "volunteer_assignments", "volunteers"
end
