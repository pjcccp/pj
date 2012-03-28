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

ActiveRecord::Schema.define(:version => 20120309085036) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domestics", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "freights", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "internationals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.string   "code"
    t.text     "notes"
    t.text     "terms"
    t.string   "status"
    t.datetime "due_date"
    t.float    "tax"
    t.float    "discount"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "quantity"
    t.float    "amount"
    t.string   "description"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipments", :force => true do |t|
    t.integer  "sender_id"
    t.string   "sender_company_name"
    t.string   "sender_name"
    t.string   "sender_address"
    t.string   "sender_phone"
    t.string   "sender_email"
    t.string   "sender_city"
    t.string   "sender_state"
    t.integer  "sender_postal_code"
    t.string   "sender_country_code"
    t.integer  "receiver_id"
    t.string   "receiver_company_name"
    t.string   "receiver_name"
    t.string   "receiver_address"
    t.string   "receiver_phone"
    t.string   "receiver_email"
    t.string   "receiver_city"
    t.string   "receiver_state"
    t.integer  "receiver_postal_code"
    t.string   "receiver_country_code"
    t.string   "receiver_residential"
    t.string   "provider"
    t.string   "rate"
    t.string   "status"
    t.date     "shipment_date"
    t.integer  "package_count"
    t.string   "fedex_service_type"
    t.string   "fedex_package_types"
    t.string   "fedex_dropoff_types"
    t.decimal  "total_net_charges"
    t.decimal  "total_surcharges"
    t.string   "total_billing_weight"
    t.decimal  "total_taxes"
    t.decimal  "total_discounts"
    t.decimal  "base_charge"
    t.integer  "client_id"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
