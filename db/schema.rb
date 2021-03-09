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

ActiveRecord::Schema.define(version: 2021_02_12_234337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_event_stream_accounts", force: :cascade do |t|
    t.bigint "admin_event_id", null: false
    t.bigint "admin_stream_account_id", null: false
    t.json "response"
    t.string "response_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "facebook_live_video_id"
    t.string "youtube_broadcast_id"
    t.string "youtube_stream_id"
    t.index ["admin_event_id"], name: "index_admin_event_stream_accounts_on_admin_event_id"
    t.index ["admin_stream_account_id"], name: "index_admin_event_stream_accounts_on_admin_stream_account_id"
  end

  create_table "admin_events", force: :cascade do |t|
    t.string "name"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.text "address"
    t.text "description"
    t.string "link"
    t.bigint "church_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "location"
    t.text "image_data"
    t.bigint "admin_live_stream_id"
    t.boolean "is_live_stream", default: false
    t.boolean "published", default: false
    t.integer "status"
    t.datetime "discarded_at"
    t.index ["admin_live_stream_id"], name: "index_admin_events_on_admin_live_stream_id"
    t.index ["church_id"], name: "index_admin_events_on_church_id"
    t.index ["discarded_at"], name: "index_admin_events_on_discarded_at"
  end

  create_table "admin_live_stream_stats", force: :cascade do |t|
    t.bigint "admin_live_stream_id", null: false
    t.string "asset_id"
    t.float "asset_duration"
    t.float "delivered_seconds"
    t.datetime "asset_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
    t.index ["admin_live_stream_id"], name: "index_admin_live_stream_stats_on_admin_live_stream_id"
    t.index ["discarded_at"], name: "index_admin_live_stream_stats_on_discarded_at"
  end

  create_table "admin_live_streams", force: :cascade do |t|
    t.string "name"
    t.string "playback_policy"
    t.string "mux_stream_id"
    t.string "mux_stream_key"
    t.bigint "church_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.string "playback_id"
    t.string "embed_code"
    t.datetime "discarded_at"
    t.index ["church_id"], name: "index_admin_live_streams_on_church_id"
    t.index ["discarded_at"], name: "index_admin_live_streams_on_discarded_at"
    t.index ["embed_code"], name: "index_admin_live_streams_on_embed_code"
  end

  create_table "admin_media_images", force: :cascade do |t|
    t.string "caption"
    t.bigint "church_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "image_data"
    t.index ["church_id"], name: "index_admin_media_images_on_church_id"
  end

  create_table "admin_media_sermons", force: :cascade do |t|
    t.string "title"
    t.string "speaker"
    t.string "scripture"
    t.bigint "church_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "video_data"
    t.boolean "published", default: false
    t.text "hls_url"
    t.text "hls_thumbnail_url"
    t.text "thumbnail_data"
    t.index ["church_id"], name: "index_admin_media_sermons_on_church_id"
  end

  create_table "admin_members", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.bigint "church_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.text "profile_picture_data"
    t.index ["church_id"], name: "index_admin_members_on_church_id"
    t.index ["email"], name: "index_admin_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_members_on_reset_password_token", unique: true
  end

  create_table "admin_news", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "church_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "image_data"
    t.index ["church_id"], name: "index_admin_news_on_church_id"
  end

  create_table "admin_simulcast_targets", force: :cascade do |t|
    t.string "stream_key"
    t.string "url"
    t.bigint "admin_live_stream_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "platform"
    t.string "mux_simulcast_id"
    t.datetime "discarded_at"
    t.index ["admin_live_stream_id"], name: "index_admin_simulcast_targets_on_admin_live_stream_id"
    t.index ["discarded_at"], name: "index_admin_simulcast_targets_on_discarded_at"
  end

  create_table "admin_stream_accounts", force: :cascade do |t|
    t.bigint "church_id", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.text "refresh_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "expires_at"
    t.text "token"
    t.index ["church_id"], name: "index_admin_stream_accounts_on_church_id"
  end

  create_table "admin_websites", force: :cascade do |t|
    t.string "primary_color"
    t.string "heading_font"
    t.string "body_font"
    t.string "youtube_live"
    t.bigint "church_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "hero_image_data"
    t.index ["church_id"], name: "index_admin_websites_on_church_id"
  end

  create_table "churches", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "phone_number"
    t.string "fb"
    t.string "youtube"
    t.string "instagram"
    t.text "give_link"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "logo_data"
    t.index ["user_id"], name: "index_churches_on_user_id"
  end

  create_table "http_requests", force: :cascade do |t|
    t.text "url"
    t.json "body"
    t.integer "type_of_request"
    t.json "response_body"
    t.string "response_code"
    t.integer "entity_id"
    t.string "entity_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "livestream_stats", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.jsonb "data"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
  end

  create_table "subscription_profiles", force: :cascade do |t|
    t.bigint "subscription_id"
    t.bigint "user_id", null: false
    t.string "stripe_customer_id"
    t.string "stripe_card_id"
    t.string "stripe_subscription_id"
    t.integer "consumed_stream_size", default: 0
    t.integer "consumed_targets", default: 0
    t.bigint "consumed_video_storage", default: 0
    t.integer "consumed_viewer_count", default: 0
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_item_id"
    t.integer "consumed_live_streams", default: 0
    t.index ["subscription_id"], name: "index_subscription_profiles_on_subscription_id"
    t.index ["user_id"], name: "index_subscription_profiles_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "name"
    t.integer "targets"
    t.integer "live_streams"
    t.integer "video_storage"
    t.integer "stream_size"
    t.integer "viewer_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
    t.float "price"
    t.string "stripe_product_id"
    t.string "stripe_price_id"
    t.integer "rank"
    t.integer "trial_period_days"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 1
    t.string "fname"
    t.string "lname"
    t.string "invite_token"
    t.datetime "invite_sent_at"
    t.boolean "invitation_completed", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "time_zone"
    t.string "subdomain"
    t.text "profile_picture_data"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email", "subdomain"], name: "index_users_on_email_and_subdomain", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_event_stream_accounts", "admin_events"
  add_foreign_key "admin_event_stream_accounts", "admin_stream_accounts"
  add_foreign_key "admin_live_stream_stats", "admin_live_streams"
  add_foreign_key "admin_live_streams", "churches"
  add_foreign_key "admin_media_images", "churches"
  add_foreign_key "admin_media_sermons", "churches"
  add_foreign_key "admin_members", "churches"
  add_foreign_key "admin_simulcast_targets", "admin_live_streams"
  add_foreign_key "admin_stream_accounts", "churches"
  add_foreign_key "admin_websites", "churches"
  add_foreign_key "churches", "users"
  add_foreign_key "subscription_profiles", "subscriptions"
  add_foreign_key "subscription_profiles", "users"
end
