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

ActiveRecord::Schema.define(version: 20150930174522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cars", force: :cascade do |t|
    t.string   "make"
    t.string   "model"
    t.integer  "capacity"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cars", ["user_id"], name: "index_cars_on_user_id", using: :btree

  create_table "fares", force: :cascade do |t|
    t.integer  "driver_id"
    t.integer  "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fares", ["driver_id"], name: "index_fares_on_driver_id", using: :btree
  add_index "fares", ["trip_id"], name: "index_fares_on_trip_id", using: :btree

  create_table "rides", force: :cascade do |t|
    t.integer  "rider_id"
    t.integer  "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rides", ["rider_id"], name: "index_rides_on_rider_id", using: :btree
  add_index "rides", ["trip_id"], name: "index_rides_on_trip_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.string   "pickup_location"
    t.string   "dropoff_location"
    t.integer  "passengers"
    t.integer  "status",             default: 0
    t.datetime "accepted_time"
    t.datetime "pickup_time"
    t.datetime "dropoff_time"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.decimal  "cost"
    t.integer  "estimated_time"
    t.integer  "estimated_distance"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "password_digest"
    t.integer  "role"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "available",       default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  add_foreign_key "cars", "users"
  add_foreign_key "fares", "trips"
  add_foreign_key "rides", "trips"
end
