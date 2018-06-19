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

ActiveRecord::Schema.define(version: 2018_06_13_161932) do

  create_table "bids", force: :cascade do |t|
    t.integer "amount", null: false
    t.boolean "accepted", default: true
    t.string "rejection_cause"
    t.string "user_email", null: false
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_bids_on_created_at"
    t.index ["room_id"], name: "index_bids_on_room_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "expires_at", null: false
    t.integer "minimal_bid", null: false
    t.integer "winner_bid", default: 0
    t.integer "winner_bid_id"
    t.string "winner_user_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_of_bids", default: 0
    t.index ["expires_at"], name: "index_rooms_on_expires_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activation_state"
    t.string "activation_code"
    t.datetime "activation_code_expires_at"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at"
    t.integer "amount_of_bids", default: 0
    t.index ["activation_code"], name: "index_users_on_activation_code"
    t.index ["email"], name: "index_users_on_email"
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end

end
