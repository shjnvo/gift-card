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

ActiveRecord::Schema[7.1].define(version: 2024_06_11_081721) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.boolean "state", default: true, null: false
    t.jsonb "customize_fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_cards", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "product_id", null: false
    t.decimal "price"
    t.string "currency"
    t.string "active_number"
    t.string "pin_code"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_cards_on_client_id"
    t.index ["product_id"], name: "index_client_cards_on_product_id"
  end

  create_table "client_products", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_products_on_client_id"
    t.index ["product_id"], name: "index_client_products_on_product_id"
    t.index ["user_id"], name: "index_client_products_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "serect_key"
    t.integer "payout_rate"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["serect_key"], name: "index_clients_on_serect_key", unique: true
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "brand_id", null: false
    t.decimal "price"
    t.string "currency"
    t.boolean "state", default: true, null: false
    t.jsonb "customize_fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "client_cards", "clients"
  add_foreign_key "client_cards", "products"
  add_foreign_key "client_products", "clients"
  add_foreign_key "client_products", "products"
  add_foreign_key "client_products", "users"
  add_foreign_key "clients", "users"
  add_foreign_key "products", "brands"
end
