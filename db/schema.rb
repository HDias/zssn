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

ActiveRecord::Schema[8.0].define(version: 2025_05_28_012234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "global_item_stocks", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.integer "total_quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_global_item_stocks_on_item_id"
  end

  create_table "infection_reports", force: :cascade do |t|
    t.integer "reporter_id"
    t.integer "reported_id"
    t.float "reporter_latitude"
    t.float "reporter_longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_items", force: :cascade do |t|
    t.bigint "survivor_id", null: false
    t.bigint "item_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_inventory_items_on_item_id"
    t.index ["survivor_id"], name: "index_inventory_items_on_survivor_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.integer "point_value", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "kind", null: false
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
    t.integer "infection_reports", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "global_item_stocks", "items"
  add_foreign_key "inventory_items", "items"
  add_foreign_key "inventory_items", "survivors"
end
