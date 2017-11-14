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

ActiveRecord::Schema.define(version: 20140725101304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_table_templates", force: true do |t|
    t.text     "permissions", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_image_galleries", force: true do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: true do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "message_id"
    t.integer  "parent_id"
    t.integer  "created_by_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configuration_options", force: true do |t|
    t.integer  "configuration_id"
    t.string   "code"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_galleries", force: true do |t|
    t.integer  "message_id"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_gallery_images", force: true do |t|
    t.integer  "message_gallery_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "author_name"
    t.text     "body",                                      null: false
    t.integer  "message_type",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",         limit: 120,                 null: false
    t.boolean  "is_anonymous",              default: true
    t.boolean  "is_published",              default: true
    t.boolean  "is_featured",               default: false
    t.integer  "position",                  default: 0
    t.integer  "created_by_id"
    t.string   "token"
  end

  create_table "news_entries", force: true do |t|
    t.integer  "news_type"
    t.string   "title",         limit: 800
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link",          limit: 2048
    t.integer  "link_hashcode", limit: 8
    t.datetime "pub_date"
    t.string   "guid",          limit: 1024
    t.string   "image"
    t.integer  "created_by_id"
  end

  add_index "news_entries", ["link_hashcode"], name: "index_news_entries_on_link_hashcode", using: :btree
  add_index "news_entries", ["pub_date"], name: "index_news_entries_on_pub_date", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operands", force: true do |t|
    t.string   "code"
    t.string   "presentation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operations", force: true do |t|
    t.string   "code"
    t.string   "presentation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "code"
    t.string   "presentation"
    t.boolean  "is_common",    default: false
    t.boolean  "is_default",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_rules", force: true do |t|
    t.integer "role_id"
    t.integer "rule_id"
  end

  create_table "rules", force: true do |t|
    t.boolean  "is_allow"
    t.boolean  "is_global"
    t.integer  "operand_id"
    t.integer  "operation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules_users", force: true do |t|
    t.integer "user_id"
    t.integer "rule_id"
  end

  create_table "surveys", force: true do |t|
    t.integer  "author_id",               null: false
    t.text     "customer_name",           null: false
    t.string   "phone"
    t.text     "address"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.text     "summary",                 null: false
    t.integer  "last_interaction_rating", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_extension"
  end

  add_index "surveys", ["author_id"], name: "index_surveys_on_author_id", using: :btree
  add_index "surveys", ["state"], name: "index_surveys_on_state", using: :btree
  add_index "surveys", ["zipcode"], name: "index_surveys_on_zipcode", using: :btree

  create_table "user_access_tables", force: true do |t|
    t.integer  "user_id",     null: false
    t.text     "permissions", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_access_tables", ["user_id"], name: "index_user_access_tables_on_user_id", using: :btree

  create_table "users", force: true do |t|
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
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
    t.boolean  "is_active"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "viewings", force: true do |t|
    t.integer  "user_id"
    t.integer  "notification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
