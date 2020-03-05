# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_04_233546) do

  create_table "cells", force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.string "picture_url"
    t.integer "game_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "game_objects", force: :cascade do |t|
    t.boolean "is_alive"
    t.string "css_class"
    t.integer "x"
    t.integer "y"
    t.string "game_type"
    t.integer "hp"
    t.integer "attack"
    t.integer "defence"
    t.integer "speed"
    t.integer "level_points"
    t.integer "range_of_sight"
    t.boolean "destructible"
    t.integer "game_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "weapon"
    t.string "armor"
  end

  create_table "games", force: :cascade do |t|
    t.integer "board_width"
    t.integer "board_heigth"
    t.integer "initial_zombies"
    t.integer "initial_npc"
    t.integer "current_score"
    t.boolean "is_running"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "turn_count"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "picture_url"
    t.string "type"
    t.boolean "weared"
    t.integer "level"
    t.string "description"
    t.integer "cell_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "non_player_charachters", force: :cascade do |t|
    t.boolean "is_alive"
    t.string "picture_url"
    t.integer "cell_id"
    t.integer "hp"
    t.integer "attack"
    t.integer "defence"
    t.integer "speed"
    t.integer "level_points"
    t.integer "range_of_sight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "obstacles", force: :cascade do |t|
    t.string "picture_url"
    t.boolean "destruclable"
    t.integer "hp"
    t.integer "cell_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "players", force: :cascade do |t|
    t.boolean "is_alive"
    t.string "picture_url"
    t.integer "cell_id"
    t.integer "hp"
    t.integer "attack"
    t.integer "defence"
    t.integer "speed"
    t.integer "level_points"
    t.integer "range_of_sight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
  end

  create_table "zombies", force: :cascade do |t|
    t.boolean "is_alive"
    t.string "picture_url"
    t.integer "cell_id"
    t.integer "hp"
    t.integer "attack"
    t.integer "defence"
    t.integer "speed"
    t.integer "range_of_sight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
