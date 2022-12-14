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

ActiveRecord::Schema.define(version: 2021_08_09_174804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_categories", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.integer "number", limit: 2, default: 1
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "actives", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.json "images"
    t.integer "price"
    t.json "desc_json"
    t.string "seo_keywords"
    t.string "seo_description"
    t.integer "rating", limit: 2, default: 10
    t.integer "random_id", limit: 2, default: 1
    t.integer "promouted", limit: 2, default: 0
    t.boolean "enabled", default: true
    t.boolean "activated", default: false
    t.boolean "deleted", default: false
    t.decimal "longitude", precision: 6, scale: 4
    t.decimal "latitude", precision: 6, scale: 4
    t.bigint "user_id", null: false
    t.bigint "active_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active_category_id"], name: "index_actives_on_active_category_id"
    t.index ["user_id"], name: "index_actives_on_user_id"
  end

  create_table "actives_towns", id: false, force: :cascade do |t|
    t.bigint "active_id", null: false
    t.bigint "town_id", null: false
    t.index ["active_id"], name: "index_actives_towns_on_active_id"
    t.index ["town_id"], name: "index_actives_towns_on_town_id"
  end

  create_table "cafebars", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.json "images"
    t.string "address"
    t.string "phone"
    t.string "site"
    t.string "email"
    t.string "instagram"
    t.string "vk"
    t.integer "rating", limit: 2, default: 10
    t.integer "random_id", limit: 2, default: 1
    t.boolean "enabled", default: true
    t.boolean "activated", default: false
    t.boolean "deleted", default: false
    t.bigint "user_id", null: false
    t.bigint "town_id", null: false
    t.decimal "longitude", precision: 6, scale: 4
    t.decimal "latitude", precision: 6, scale: 4
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "desc_json"
    t.index ["town_id"], name: "index_cafebars_on_town_id"
    t.index ["user_id"], name: "index_cafebars_on_user_id"
  end

  create_table "cafebars_tagcafebars", id: false, force: :cascade do |t|
    t.bigint "cafebar_id", null: false
    t.bigint "tagcafebar_id", null: false
    t.index ["cafebar_id"], name: "index_cafebars_tagcafebars_on_cafebar_id"
    t.index ["tagcafebar_id"], name: "index_cafebars_tagcafebars_on_tagcafebar_id"
  end

  create_table "carts", force: :cascade do |t|
  end

  create_table "category_counters", force: :cascade do |t|
    t.bigint "town_id", null: false
    t.string "cat_type"
    t.integer "cat_id"
    t.integer "cat_count", limit: 2, default: 1
    t.string "cat_name"
    t.index ["town_id"], name: "index_category_counters_on_town_id"
  end

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
    t.decimal "latitude", precision: 6, scale: 4
    t.decimal "longitude", precision: 6, scale: 4
    t.boolean "all_year", default: false
    t.json "desc_json"
    t.boolean "activated", default: false
    t.boolean "enabled", default: true
    t.boolean "deleted", default: false
    t.index ["hotel_category_id"], name: "index_hotels_on_hotel_category_id"
    t.index ["town_id"], name: "index_hotels_on_town_id"
    t.index ["user_id"], name: "index_hotels_on_user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.string "resource_name"
    t.integer "resource_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
  end

  create_table "order_actives", force: :cascade do |t|
    t.string "guest_name"
    t.string "guest_email"
    t.string "guest_phone"
    t.date "wish_date"
    t.integer "adults", limit: 2
    t.text "wishes"
    t.integer "price"
    t.boolean "payment_successful", default: false
    t.integer "user_id"
    t.bigint "active_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active_id"], name: "index_order_actives_on_active_id"
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

  create_table "point_categories", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.integer "number", limit: 2, default: 1
  end

  create_table "points", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.json "images"
    t.string "address"
    t.text "how_to_get"
    t.json "desc_json"
    t.integer "rating", limit: 2, default: 10
    t.integer "random_id", limit: 2, default: 1
    t.boolean "enabled", default: true
    t.boolean "activated", default: false
    t.boolean "deleted", default: false
    t.bigint "user_id", null: false
    t.bigint "town_id", null: false
    t.bigint "point_category_id", null: false
    t.decimal "longitude", precision: 6, scale: 4
    t.decimal "latitude", precision: 6, scale: 4
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["point_category_id"], name: "index_points_on_point_category_id"
    t.index ["town_id"], name: "index_points_on_town_id"
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.json "images"
    t.integer "number", default: 1
    t.integer "size"
    t.bigint "hotel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar"
    t.json "description"
    t.index ["hotel_id"], name: "index_rooms_on_hotel_id"
  end

  create_table "service_categories", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.integer "number", limit: 2, default: 1
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.json "images"
    t.string "address"
    t.json "desc_json"
    t.integer "rating", limit: 2, default: 10
    t.integer "random_id", limit: 2, default: 1
    t.boolean "enabled", default: true
    t.boolean "activated", default: false
    t.boolean "deleted", default: false
    t.decimal "longitude", precision: 6, scale: 4
    t.decimal "latitude", precision: 6, scale: 4
    t.bigint "user_id", null: false
    t.bigint "service_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_category_id"], name: "index_services_on_service_category_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "services_towns", id: false, force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "town_id", null: false
    t.index ["service_id"], name: "index_services_towns_on_service_id"
    t.index ["town_id"], name: "index_services_towns_on_town_id"
  end

  create_table "tagcafebars", force: :cascade do |t|
    t.string "name"
    t.string "icon"
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
    t.string "avatar"
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "actives", "active_categories"
  add_foreign_key "actives", "users"
  add_foreign_key "actives_towns", "actives"
  add_foreign_key "actives_towns", "towns"
  add_foreign_key "cafebars", "towns"
  add_foreign_key "cafebars", "users"
  add_foreign_key "cafebars_tagcafebars", "cafebars"
  add_foreign_key "cafebars_tagcafebars", "tagcafebars"
  add_foreign_key "category_counters", "towns"
  add_foreign_key "hotels", "hotel_categories"
  add_foreign_key "hotels", "towns"
  add_foreign_key "hotels", "users"
  add_foreign_key "line_items", "carts"
  add_foreign_key "order_actives", "actives"
  add_foreign_key "orders", "hotels"
  add_foreign_key "points", "point_categories"
  add_foreign_key "points", "towns"
  add_foreign_key "points", "users"
  add_foreign_key "rooms", "hotels"
  add_foreign_key "services", "service_categories"
  add_foreign_key "services", "users"
  add_foreign_key "services_towns", "services"
  add_foreign_key "services_towns", "towns"
end
