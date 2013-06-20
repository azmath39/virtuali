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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130620021722) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "refund"
    t.integer  "activity_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.float    "balance"
    t.float    "charge"
  end

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "assigned_coupons", :force => true do |t|
    t.integer  "coupon_id"
    t.integer  "user_id"
    t.date     "valid_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cards", :force => true do |t|
    t.string   "subcription_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "logo"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "phno"
  end

  create_table "coupon_transactions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "coupon_id"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "coupons", :force => true do |t|
    t.string   "code"
    t.string   "company"
    t.date     "expire_date"
    t.date     "valid_date"
    t.string   "company_email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.float    "value"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "drafts", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.text     "description"
    t.integer  "user_id"
    t.string   "city"
    t.string   "zip"
    t.string   "subdivision"
    t.float    "price"
    t.integer  "square_footage"
    t.integer  "bed_rooms"
    t.integer  "bath_rooms"
    t.integer  "product_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "slug"
    t.text     "address"
    t.integer  "status"
    t.integer  "selected_package_id"
    t.datetime "deleted_at"
    t.string   "address1"
    t.string   "address2"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "acreage"
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "satisfaction_status"
    t.text     "content"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "messages", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "body"
    t.integer  "tour_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.integer  "pictures_for_tour"
    t.integer  "status"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "subscription_period"
    t.integer  "add_on"
    t.float    "regular_price"
    t.float    "special_price"
    t.integer  "no_of_tours"
    t.integer  "package_type"
  end

  create_table "paintings", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "tour_id"
    t.integer  "user_id"
    t.integer  "priority"
    t.integer  "draft_id"
    t.boolean  "select_image", :default => false
  end

  create_table "payments", :force => true do |t|
    t.float    "amount"
    t.string   "reference"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "payment_type"
    t.integer  "user_id"
    t.string   "email"
    t.string   "name"
    t.integer  "product_id"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "category_id"
    t.integer  "product_type"
  end

  create_table "selected_packages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "package_id"
    t.integer  "price"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "status"
    t.date     "expire_date"
    t.integer  "pictures_for_tour"
    t.integer  "payment_period_type"
    t.date     "renew_date"
  end

  create_table "selected_products", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "space_usages", :force => true do |t|
    t.float    "size"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tours", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "city"
    t.string   "zip"
    t.string   "subdivision"
    t.integer  "price"
    t.integer  "square_footage"
    t.integer  "bed_rooms"
    t.integer  "bath_rooms"
    t.integer  "product_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "slug"
    t.text     "address"
    t.integer  "status"
    t.integer  "selected_package_id"
    t.datetime "deleted_at"
    t.string   "address1"
    t.string   "address2"
    t.string   "acreage"
  end

  add_index "tours", ["slug"], :name => "index_tours_on_cached_slug"

  create_table "user_delay_jobs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "delayed_job_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "image"
    t.string   "name"
    t.string   "phno"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "add1"
    t.string   "add2"
    t.string   "state"
    t.string   "city"
    t.string   "zipcode"
    t.float    "balance"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
