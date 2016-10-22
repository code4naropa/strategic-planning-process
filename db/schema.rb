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

ActiveRecord::Schema.define(version: 20161016184819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "uuid-ossp"

  create_table "comments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "author_id"
    t.uuid     "commentable_id"
    t.string   "content"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "likes_count",      default: 0
    t.string   "commentable_type"
    t.index ["author_id"], name: "index_comments_on_author_id", using: :btree
    t.index ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["created_at"], name: "index_comments_on_created_at", using: :btree
  end

  create_table "democracy_communities", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_democracy_communities_on_created_at", using: :btree
  end

  create_table "democracy_community_decisions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "community_id"
    t.integer  "author_id"
    t.string   "title"
    t.text     "description"
    t.datetime "ends_at"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.text     "votes_count",  default: "---\n:total: 0\n:upvotes: 0\n:downvotes: 0\n"
    t.index ["author_id"], name: "index_democracy_community_decisions_on_author_id", using: :btree
    t.index ["community_id"], name: "index_democracy_community_decisions_on_community_id", using: :btree
    t.index ["created_at"], name: "index_democracy_community_decisions_on_created_at", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "liker_id"
    t.uuid     "likable_id"
    t.string   "likable_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable_type_and_likable_id", using: :btree
    t.index ["liker_id"], name: "index_likes_on_liker_id", using: :btree
  end

  create_table "posts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "author_id"
    t.text     "content",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "likes_count", default: 0
    t.index ["author_id"], name: "index_posts_on_author_id", using: :btree
    t.index ["created_at"], name: "index_posts_on_created_at", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "visibility", default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.citext   "username",                               null: false
    t.string   "password_digest"
    t.string   "name"
    t.datetime "last_seen_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "confirmed_registration", default: false, null: false
    t.string   "registration_token"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["registration_token"], name: "index_users_on_registration_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "voter_id"
    t.uuid     "votable_id"
    t.string   "votable_type"
    t.integer  "vote",         default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id", using: :btree
    t.index ["voter_id"], name: "index_votes_on_voter_id", using: :btree
  end

  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "democracy_community_decisions", "democracy_communities", column: "community_id"
  add_foreign_key "democracy_community_decisions", "users", column: "author_id"
  add_foreign_key "likes", "users", column: "liker_id"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "votes", "users", column: "voter_id"
end
