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

ActiveRecord::Schema.define(version: 20150723114622) do

  create_table "topics", force: :cascade do |t|
    t.string   "tid"
    t.string   "slary"
    t.string   "area"
    t.string   "company"
    t.string   "level"
    t.string   "title"
    t.datetime "pub_created_at"
    t.datetime "pub_updated_at"
    t.datetime "replied_at"
    t.integer  "replies_count"
    t.string   "node_name"
    t.integer  "node_id"
    t.integer  "last_reply_user_id"
    t.string   "last_reply_user_login"
    t.string   "user"
    t.string   "deleted"
    t.string   "abilities"
    t.text     "body"
    t.text     "body_html"
    t.integer  "hits"
    t.boolean  "isdeal"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

end
