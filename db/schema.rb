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

ActiveRecord::Schema.define(version: 2021_02_20_085700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hotel_categories", force: :cascade do |t|
    t.string "name"
    t.integer "number", limit: 2, default: 1
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.integer "price_from"
    t.string "address"
    t.integer "distance_to_sea", limit: 2
    t.string "avatar"
    t.json "images"
    t.integer "rating", limit: 2, default: 20
    t.integer "random_number", limit: 2, default: 1
    t.string "site"
    t.string "email"
    t.bigint "user_id", null: false
    t.bigint "town_id", null: false
    t.bigint "hotel_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hotel_category_id"], name: "index_hotels_on_hotel_category_id"
    t.index ["town_id"], name: "index_hotels_on_town_id"
    t.index ["user_id"], name: "index_hotels_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "guest_name"
    t.string "guest_email"
    t.string "guest_phone"
    t.date "check_in"
    t.date "check_out"
    t.integer "adults", limit: 2
    t.integer "kids", limit: 2
    t.integer "room_id"
    t.text "wishes"
    t.boolean "reservation_confirmed", default: false
    t.boolean "payment_successful", default: false
    t.string "owner_comment"
    t.integer "total_amount"
    t.integer "user_id"
    t.bigint "hotel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hotel_id"], name: "index_orders_on_hotel_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.json "images"
    t.integer "number", default: 1
    t.integer "size"
    t.bigint "hotel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hotel_id"], name: "index_rooms_on_hotel_id"
  end

  create_table "towns", force: :cascade do |t|
    t.string "name"
    t.string "parent_name"
    t.string "avatar"
    t.integer "number", limit: 2, default: 1
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "hotels", "hotel_categories"
  add_foreign_key "hotels", "towns"
  add_foreign_key "hotels", "users"
  add_foreign_key "orders", "hotels"
  add_foreign_key "rooms", "hotels"
end
