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

ActiveRecord::Schema.define(version: 20140907114929) do

  create_table "obstacle_types", force: true do |t|
    t.string   "name",       limit: 25, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "obstacle_types", ["name"], name: "index_obstacle_types_on_name", unique: true

  create_table "obstacles", force: true do |t|
    t.integer  "type_id",    null: false
    t.string   "geometry"
    t.integer  "spot_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "obstacles", ["spot_id"], name: "index_obstacles_on_spot_id"
  add_index "obstacles", ["type_id"], name: "index_obstacles_on_type_id"

  create_table "skate_spots", force: true do |t|
    t.decimal  "longitude"
    t.decimal  "latitude"
    t.string   "geometry"
    t.integer  "name_id"
    t.boolean  "park"
    t.integer  "style"
    t.boolean  "undercover"
    t.integer  "cost"
    t.string   "currency",         limit: 3
    t.boolean  "lights"
    t.boolean  "private_property"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skate_spots", ["name_id"], name: "index_skate_spots_on_name_id"

  create_table "spot_names", force: true do |t|
    t.string   "name",       limit: 80, null: false
    t.integer  "spot_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spot_names", ["spot_id"], name: "index_spot_names_on_spot_id"

end
