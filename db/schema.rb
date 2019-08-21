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

ActiveRecord::Schema.define(version: 20190221002043) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "plaid_accounts", id: :string, force: :cascade do |t|
    t.string   "plaid_item_id", null: false
    t.string   "name"
    t.string   "official_name"
    t.string   "account_type"
    t.string   "subtype"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "plaid_items", id: :string, force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.string   "institution_id", null: false
    t.string   "access_token",   null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["user_id"], name: "index_plaid_items_on_user_id", using: :btree
  end

  create_table "plaid_transactions", id: :string, force: :cascade do |t|
    t.string   "plaid_account_id",  null: false
    t.float    "amount",            null: false
    t.date     "date"
    t.string   "iso_currency_code"
    t.string   "description"
    t.boolean  "pending"
    t.string   "transaction_type"
    t.string   "category_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "transaction_categories", force: :cascade do |t|
    t.integer  "transaction_id"
    t.string   "category"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["transaction_id"], name: "index_transaction_categories_on_transaction_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   null: false
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
