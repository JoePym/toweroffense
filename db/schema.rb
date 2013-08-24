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

ActiveRecord::Schema.define(version: 20130824140139) do

  create_table "cards", force: true do |t|
    t.string   "name"
    t.boolean  "legendary",  default: false, null: false
    t.integer  "rating"
    t.integer  "width"
    t.integer  "range"
    t.integer  "cost"
    t.string   "card_type"
    t.string   "monster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deck_cards", force: true do |t|
    t.integer  "card_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deck_cards", ["card_id"], name: "index_deck_cards_on_card_id"
  add_index "deck_cards", ["player_id"], name: "index_deck_cards_on_player_id"

  create_table "players", force: true do |t|
    t.integer  "square",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "squares", force: true do |t|
    t.integer  "x"
    t.integer  "y"
    t.integer  "index"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
