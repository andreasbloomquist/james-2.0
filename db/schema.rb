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

ActiveRecord::Schema.define(version: 20150715184223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.integer  "broker_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "admins", ["broker_id"], name: "index_admins_on_broker_id", using: :btree

  create_table "appointment", force: :cascade do |t|
    t.datetime "option_one"
    t.datetime "option_two"
    t.datetime "option_three"
    t.string   "user_response"
    t.string   "calendar_url"
    t.string   "broker_availability_url"
    t.integer  "broker_id"
    t.integer  "lead_id"
    t.integer  "property_id"
  end

  add_index "appointment", ["broker_id"], name: "index_appointment_on_broker_id", using: :btree
  add_index "appointment", ["lead_id"], name: "index_appointment_on_lead_id", using: :btree

  create_table "appointments", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "option_one"
    t.datetime "option_two"
    t.datetime "option_three"
    t.string   "user_response"
    t.string   "calendar_url"
    t.string   "availability_url"
    t.integer  "broker_id"
    t.integer  "property_id"
  end

  create_table "brokers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "company"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string   "q_one"
    t.string   "q_two"
    t.string   "q_three"
    t.string   "q_four"
    t.string   "q_five"
    t.boolean  "complete"
    t.integer  "user_id"
    t.string   "response_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "q_six"
  end

  add_index "leads", ["user_id"], name: "index_leads_on_user_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "address"
    t.string   "sub_market"
    t.string   "property_type"
    t.integer  "sq_ft"
    t.datetime "available"
    t.string   "min"
    t.string   "max"
    t.string   "description"
    t.string   "response_code"
    t.integer  "lead_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "broker_id"
    t.decimal  "rent_price"
    t.string   "image_url"
  end

  add_index "properties", ["lead_id"], name: "index_properties_on_lead_id", using: :btree

  create_table "sms_logs", force: :cascade do |t|
    t.string   "from"
    t.string   "to"
    t.string   "body"
    t.string   "sms_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "admins", "brokers"
  add_foreign_key "appointment", "brokers"
  add_foreign_key "appointment", "leads"
  add_foreign_key "leads", "users"
  add_foreign_key "properties", "leads"
end
