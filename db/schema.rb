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

ActiveRecord::Schema.define(version: 20130621053952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "company_id"
    t.boolean  "accepted"
    t.text     "body"
    t.tsvector "tsv"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["accepted"], name: "index_answers_on_accepted", using: :btree
  add_index "answers", ["company_id"], name: "index_answers_on_company_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["score"], name: "index_answers_on_score", using: :btree
  add_index "answers", ["tsv"], name: "answers_fti", using: :gin
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "answer_id"
    t.integer  "user_id"
    t.integer  "company_id"
    t.text     "body"
    t.tsvector "tsv"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["answer_id"], name: "index_comments_on_answer_id", using: :btree
  add_index "comments", ["company_id"], name: "index_comments_on_company_id", using: :btree
  add_index "comments", ["score"], name: "index_comments_on_score", using: :btree
  add_index "comments", ["tsv"], name: "comments_fti", using: :gin
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "uuid"
    t.string   "name"
    t.text     "description"
    t.integer  "owner_id"
    t.string   "maildrop_address"
    t.text     "welcome_message"
    t.boolean  "auto_create_questions_from_email"
    t.boolean  "default_questions_to_public"
    t.boolean  "site_public"
    t.string   "logo"
    t.string   "favicon"
    t.text     "styles"
    t.string   "cname"
    t.string   "slug"
    t.string   "welcome_message_sidebar_widget_title"
    t.boolean  "welcome_message_sidebar_widget_enabled", default: true
    t.boolean  "site_links_sidebar_widget_enabled",      default: true
    t.boolean  "tag_box_sidebar_widget_enabled",         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tagline"
  end

  add_index "companies", ["cname"], name: "index_companies_on_cname", using: :btree
  add_index "companies", ["maildrop_address"], name: "index_companies_on_maildrop_address", using: :btree
  add_index "companies", ["owner_id"], name: "index_companies_on_owner_id", using: :btree
  add_index "companies", ["slug"], name: "index_companies_on_slug", using: :btree
  add_index "companies", ["uuid"], name: "index_companies_on_uuid", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "links", force: true do |t|
    t.integer "company_id"
    t.string  "title"
    t.string  "url"
    t.integer "position"
  end

  add_index "links", ["company_id"], name: "index_links_on_company_id", using: :btree
  add_index "links", ["position"], name: "index_links_on_position", using: :btree

  create_table "question_tags", force: true do |t|
    t.integer "question_id"
    t.integer "tag_id"
  end

  add_index "question_tags", ["question_id"], name: "index_question_tags_on_question_id", using: :btree
  add_index "question_tags", ["tag_id"], name: "index_question_tags_on_tag_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "uuid"
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "accepted_answer_id"
    t.string   "title"
    t.text     "body"
    t.tsvector "tsv"
    t.string   "slug"
    t.string   "visibility"
    t.boolean  "site_public"
    t.boolean  "closed"
    t.string   "email"
    t.integer  "score"
    t.string   "tag_names"
    t.datetime "last_response_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["accepted_answer_id"], name: "index_questions_on_accepted_answer_id", using: :btree
  add_index "questions", ["company_id"], name: "index_questions_on_company_id", using: :btree
  add_index "questions", ["created_at"], name: "index_questions_on_created_at", using: :btree
  add_index "questions", ["last_response_date"], name: "index_questions_on_last_response_date", using: :btree
  add_index "questions", ["site_public"], name: "index_questions_on_site_public", using: :btree
  add_index "questions", ["slug"], name: "index_questions_on_slug", using: :btree
  add_index "questions", ["tsv"], name: "questions_fti", using: :gin
  add_index "questions", ["updated_at"], name: "index_questions_on_updated_at", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree
  add_index "questions", ["uuid"], name: "index_questions_on_uuid", using: :btree

  create_table "tags", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "tags", ["company_id"], name: "index_tags_on_company_id", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["score"], name: "index_tags_on_score", using: :btree
  add_index "tags", ["slug"], name: "index_tags_on_slug", using: :btree

  create_table "team_members", force: true do |t|
    t.string   "uuid"
    t.integer  "company_id"
    t.integer  "user_id"
    t.boolean  "notify_of_new_questions"
    t.boolean  "notify_of_new_answers_or_comments"
    t.string   "title"
    t.string   "role"
    t.string   "email"
    t.string   "token"
    t.string   "status"
    t.boolean  "featured"
    t.integer  "sort_position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_members", ["company_id"], name: "index_team_members_on_company_id", using: :btree
  add_index "team_members", ["featured"], name: "index_team_members_on_featured", using: :btree
  add_index "team_members", ["notify_of_new_answers_or_comments"], name: "index_team_members_on_notify_of_new_answers_or_comments", using: :btree
  add_index "team_members", ["notify_of_new_questions"], name: "index_team_members_on_notify_of_new_questions", using: :btree
  add_index "team_members", ["sort_position"], name: "index_team_members_on_sort_position", using: :btree
  add_index "team_members", ["token"], name: "index_team_members_on_token", using: :btree
  add_index "team_members", ["user_id"], name: "index_team_members_on_user_id", using: :btree
  add_index "team_members", ["uuid"], name: "index_team_members_on_uuid", using: :btree

  create_table "users", force: true do |t|
    t.string   "uuid"
    t.string   "username"
    t.string   "email",                                  default: "", null: false
    t.string   "encrypted_password",                     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nickname"
    t.string   "plan"
    t.boolean  "trial"
    t.datetime "trial_end_date"
    t.integer  "trial_timeout_job_id"
    t.boolean  "canceled"
    t.string   "avatar"
    t.boolean  "active"
    t.boolean  "account_on_hold"
    t.boolean  "company_owner"
    t.string   "time_zone"
    t.boolean  "notify_of_responses_to_questions"
    t.boolean  "notify_of_responses_to_participated_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["notify_of_responses_to_participated_in"], name: "index_users_on_notify_of_responses_to_participated_in", using: :btree
  add_index "users", ["notify_of_responses_to_questions"], name: "index_users_on_notify_of_responses_to_questions", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["votable_id"], name: "index_votes_on_votable_id", using: :btree
  add_index "votes", ["votable_type"], name: "index_votes_on_votable_type", using: :btree

end
