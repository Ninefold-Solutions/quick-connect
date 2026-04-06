# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_06_062708) do
  create_table "abouts", force: :cascade do |t|
    t.string "address", default: ""
    t.string "breif", default: ""
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.string "habit", default: ""
    t.string "met", default: ""
    t.string "other", default: ""
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "work", default: ""
    t.index ["contact_id"], name: "index_abouts_on_contact_id"
    t.index ["user_id"], name: "index_abouts_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "expired", default: false, null: false
    t.string "name"
    t.integer "owner_id"
    t.datetime "updated_at", null: false
  end

  create_table "activities", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.integer "group_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_activities_on_account_id"
    t.index ["group_id"], name: "index_activities_on_group_id"
  end

  create_table "batches", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["account_id"], name: "index_batches_on_account_id"
  end

  create_table "batches_collections", id: false, force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "batches_contacts", id: false, force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id", "batch_id"], name: "index_batches_contacts_on_contact_id_and_batch_id", unique: true
  end

  create_table "collections", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_collections_on_account_id"
  end

  create_table "contact_activities", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.string "body"
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["activity_id"], name: "index_contact_activities_on_activity_id"
    t.index ["contact_id"], name: "index_contact_activities_on_contact_id"
    t.index ["user_id"], name: "index_contact_activities_on_user_id"
  end

  create_table "contact_events", force: :cascade do |t|
    t.string "body"
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.integer "life_event_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["contact_id"], name: "index_contact_events_on_contact_id"
    t.index ["life_event_id"], name: "index_contact_events_on_life_event_id"
    t.index ["user_id"], name: "index_contact_events_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "about", default: ""
    t.integer "account_id"
    t.integer "activity_count", default: 0
    t.string "address", default: ""
    t.boolean "archived", default: false
    t.date "archived_on"
    t.datetime "birthday"
    t.datetime "created_at", null: false
    t.string "email", default: ""
    t.boolean "favorite", default: false, null: false
    t.string "first_name", default: "", null: false
    t.date "followup_after_changed_on"
    t.string "intro"
    t.string "last_name", default: "", null: false
    t.string "phone", default: ""
    t.integer "relation_id"
    t.integer "touch_back_after", default: 0
    t.date "touched_at"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_contacts_on_account_id"
    t.index ["first_name"], name: "index_contacts_on_first_name"
    t.index ["relation_id"], name: "index_contacts_on_relation_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "contacts_labels", id: false, force: :cascade do |t|
    t.integer "contact_id", null: false
    t.integer "label_id", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.integer "field_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_conversations_on_contact_id"
    t.index ["field_id"], name: "index_conversations_on_field_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "debts", force: :cascade do |t|
    t.string "amount"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "due_date"
    t.string "owed_by", default: "user"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_debts_on_contact_id"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "comments"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.string "filename"
    t.string "link"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_documents_on_contact_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "action"
    t.string "action_context"
    t.string "action_for_context"
    t.datetime "created_at", null: false
    t.integer "eventable_id"
    t.string "eventable_type"
    t.integer "trackable_id"
    t.string "trackable_type"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_events_on_account_id"
  end

  create_table "fields", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.string "icon"
    t.string "name", null: false
    t.string "protocol"
    t.boolean "type", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_fields_on_account_id"
  end

  create_table "gifts", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "date"
    t.string "name"
    t.string "status", default: "received"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_gifts_on_contact_id"
    t.index ["user_id"], name: "index_gifts_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "category", default: "activity", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "labels", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "color", default: "gray", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_labels_on_account_id"
  end

  create_table "life_events", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.integer "group_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_life_events_on_account_id"
    t.index ["group_id"], name: "index_life_events_on_group_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer "contact_id"
    t.string "link"
    t.string "link_type"
    t.integer "user_id"
    t.index ["contact_id"], name: "index_links_on_contact_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.string "title", default: ""
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_notes_on_contact_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "phone_calls", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.string "status", default: "contact", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_phone_calls_on_contact_id"
    t.index ["user_id"], name: "index_phone_calls_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.string "key"
    t.string "message"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["account_id"], name: "index_preferences_on_account_id"
  end

  create_table "relations", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_relations_on_account_id"
  end

  create_table "relatives", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.integer "first_contact_id"
    t.string "name"
    t.integer "relation_id"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_relatives_on_account_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.integer "account_id"
    t.string "comments"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.integer "remind_after"
    t.date "reminder_date"
    t.integer "reminder_type"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_reminders_on_account_id"
    t.index ["contact_id"], name: "index_reminders_on_contact_id"
    t.index ["user_id"], name: "index_reminders_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", limit: 4, null: false
    t.datetime "created_at", null: false
    t.binary "key", limit: 1024, null: false
    t.integer "key_hash", limit: 8, null: false
    t.binary "value", limit: 536870912, null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.text "body"
    t.boolean "completed", default: false
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "due_date"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_tasks_on_contact_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "account_id"
    t.integer "admin", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.integer "permission", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  add_foreign_key "abouts", "contacts"
  add_foreign_key "abouts", "users"
  add_foreign_key "activities", "accounts"
  add_foreign_key "activities", "groups"
  add_foreign_key "batches", "accounts"
  add_foreign_key "collections", "accounts"
  add_foreign_key "contact_activities", "activities"
  add_foreign_key "contact_activities", "contacts"
  add_foreign_key "contact_activities", "users"
  add_foreign_key "contact_events", "contacts"
  add_foreign_key "contact_events", "life_events"
  add_foreign_key "contact_events", "users"
  add_foreign_key "contacts", "accounts"
  add_foreign_key "contacts", "relations"
  add_foreign_key "contacts", "users"
  add_foreign_key "conversations", "contacts"
  add_foreign_key "conversations", "fields"
  add_foreign_key "conversations", "users"
  add_foreign_key "debts", "contacts"
  add_foreign_key "debts", "users"
  add_foreign_key "documents", "contacts"
  add_foreign_key "documents", "users"
  add_foreign_key "events", "accounts"
  add_foreign_key "fields", "accounts"
  add_foreign_key "gifts", "contacts"
  add_foreign_key "gifts", "users"
  add_foreign_key "labels", "accounts"
  add_foreign_key "life_events", "accounts"
  add_foreign_key "life_events", "groups"
  add_foreign_key "links", "contacts"
  add_foreign_key "links", "users"
  add_foreign_key "notes", "contacts"
  add_foreign_key "notes", "users"
  add_foreign_key "phone_calls", "contacts"
  add_foreign_key "phone_calls", "users"
  add_foreign_key "preferences", "accounts"
  add_foreign_key "relations", "accounts"
  add_foreign_key "relatives", "accounts"
  add_foreign_key "reminders", "accounts"
  add_foreign_key "reminders", "contacts"
  add_foreign_key "reminders", "users"
  add_foreign_key "tasks", "contacts"
  add_foreign_key "tasks", "users"
  add_foreign_key "users", "accounts"
  add_foreign_key "users", "users"
end
