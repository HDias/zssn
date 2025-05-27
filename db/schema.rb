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

ActiveRecord::Schema[8.0].define(version: 2025_05_26_040009) do
  create_table "infection_reports", force: :cascade do |t|
    t.integer "reporter_id"
    t.integer "reported_id"
    t.float "reporter_latitude"
    t.float "reporter_longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survivors", force: :cascade do |t|
    t.string "name", null: false
    t.integer "age", null: false
    t.string "gender", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.boolean "infected", default: false, null: false
    t.integer "infection_reports"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "url_accesses", force: :cascade do |t|
    t.integer "url_id", null: false
    t.datetime "accessed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url_id"], name: "index_url_accesses_on_url_id"
  end

  create_table "urls", force: :cascade do |t|
    t.string "original_url"
    t.string "short_code"
    t.integer "access_count"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "url_accesses", "urls"
end
