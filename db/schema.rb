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

ActiveRecord::Schema.define(version: 20140321014420) do

  create_table "comments", force: true do |t|
    t.string   "label"
    t.string   "statement"
    t.integer  "commentor_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "task_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "task_anc_desc_udx", unique: true
  add_index "task_hierarchies", ["descendant_id"], name: "task_desc_idx"

  create_table "tasks", force: true do |t|
    t.integer  "parent_id"
    t.string   "statement"
    t.string   "next_action"
    t.string   "status",       default: "Active"
    t.datetime "active_at"
    t.datetime "done_at"
    t.datetime "someday_at"
    t.datetime "cancelled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "master_id"
  end

  create_table "tasks_users", force: true do |t|
    t.integer "task_id"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
