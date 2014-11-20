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

ActiveRecord::Schema.define(version: 20141119100338) do

  create_table "Products_Per_Categories", id: false, force: true do |t|
    t.string  "name",              limit: 150
    t.integer "COUNT(product.id)", limit: 8
  end

  create_table "Review per Site", id: false, force: true do |t|
    t.integer "COUNT(review.id)", limit: 8
    t.string  "site",             limit: 100
  end

  create_table "Total Products in DB", id: false, force: true do |t|
    t.integer "count(*)", limit: 8
  end

  create_table "Total Reviews in DB", id: false, force: true do |t|
    t.integer "count(*)", limit: 8
  end

  create_table "Visitor Analytics", id: false, force: true do |t|
    t.datetime "Date/Time"
    t.string   "IP Address",    limit: 30
    t.integer  "OEM User ID"
    t.string   "Browser"
    t.string   "Referrer",      limit: 300
    t.string   "Page Name",     limit: 100
    t.string   "Action Name",   limit: 50
    t.string   "Action Param1", limit: 300
    t.string   "Action Param2", limit: 100
    t.string   "Action Param3", limit: 100
  end

  create_table "auth_token", primary_key: "token", force: true do |t|
    t.integer "oem_user_id"
  end

  add_index "auth_token", ["oem_user_id"], name: "FK8B5E1CA22AD395FD", using: :btree
  add_index "auth_token", ["token"], name: "token", unique: true, using: :btree

  create_table "category", force: true do |t|
    t.integer "parent_id"
    t.string  "name",           limit: 150
    t.integer "products_count"
    t.integer "attrib_left"
    t.integer "attrib_right"
  end

  create_table "country", primary_key: "iso", force: true do |t|
    t.string "name",           limit: 80, null: false
    t.string "printable_name", limit: 80, null: false
  end

  create_table "country_state", force: true do |t|
    t.string "country_iso", limit: 2,  null: false
    t.string "short_name",  limit: 5
    t.string "name",        limit: 50, null: false
  end

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

  create_table "limitations", force: true do |t|
    t.integer  "user_id"
    t.integer  "my_lists"
    t.integer  "products_per_list"
    t.integer  "prm_reports"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maillist", force: true do |t|
    t.string "name",        limit: 50,  null: false
    t.string "description", limit: 300
  end

  create_table "manufacturer", primary_key: "name", force: true do |t|
    t.string  "id",     limit: 32,                 null: false
    t.boolean "hidden",            default: false, null: false
  end

  add_index "manufacturer", ["id"], name: "id", using: :btree

  create_table "oem_user", force: true do |t|
    t.integer "isActive"
    t.string  "phone_num",    limit: 20
    t.string  "last_name",    limit: 100
    t.string  "first_name",   limit: 100
    t.integer "isWidgetDemo"
    t.string  "email",        limit: 100
    t.string  "company",      limit: 200
    t.integer "isAdmin"
    t.string  "password",     limit: 50
    t.string  "username",     limit: 100, null: false
  end

  add_index "oem_user", ["username"], name: "idx_username", using: :btree

  create_table "oem_user_backup", force: true do |t|
    t.integer "isActive"
    t.string  "phone_num",    limit: 20
    t.string  "last_name",    limit: 100
    t.string  "first_name",   limit: 100
    t.integer "isWidgetDemo"
    t.string  "email",        limit: 100
    t.string  "company",      limit: 200
    t.integer "isAdmin"
    t.string  "password",     limit: 50
    t.string  "username",     limit: 100, null: false
  end

  create_table "oem_user_role", id: false, force: true do |t|
    t.integer "oem_user_id", null: false
    t.integer "role_id",     null: false
  end

  add_index "oem_user_role", ["oem_user_id"], name: "FK94C31B822AD395FD", using: :btree
  add_index "oem_user_role", ["role_id"], name: "FK94C31B82BC63A9D1", using: :btree

  create_table "opinion_queue", force: true do |t|
    t.string  "product_id", limit: 32, null: false
    t.integer "user_id",               null: false
  end

  create_table "paper_downloads", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "paper_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prm_category_subscriptions", force: true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prm_category_subscriptions", ["category_id"], name: "category_id", using: :btree
  add_index "prm_category_subscriptions", ["id"], name: "index_prm_category_subscriptions_on_id", using: :btree
  add_index "prm_category_subscriptions", ["user_id"], name: "index_prm_category_subscriptions_on_user_id", using: :btree

  create_table "prm_delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prm_product_reports", force: true do |t|
    t.integer  "product_category_id"
    t.string   "manufacturer_id",       limit: 32
    t.integer  "sorting_field"
    t.integer  "sorting_order"
    t.integer  "number_of_reviews"
    t.integer  "csi_range"
    t.integer  "pfs_range"
    t.integer  "prs_range"
    t.integer  "pss_range"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "per_page"
    t.boolean  "filtered"
    t.string   "product_category_type"
    t.integer  "last_updated_filter"
    t.integer  "nps_range"
    t.integer  "nps_posneg"
  end

  add_index "prm_product_reports", ["id"], name: "index_prm_product_reports_on_id", using: :btree
  add_index "prm_product_reports", ["manufacturer_id"], name: "manufacturer_id", using: :btree
  add_index "prm_product_reports", ["product_category_id"], name: "product_category_id", using: :btree
  add_index "prm_product_reports", ["user_id"], name: "index_prm_product_reports_on_user_id", using: :btree

  create_table "prm_report_manufacturers", force: true do |t|
    t.integer  "report_id"
    t.string   "manufacturer_id", limit: 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prm_report_manufacturers", ["manufacturer_id"], name: "manufacturer_id", using: :btree
  add_index "prm_report_manufacturers", ["report_id"], name: "index_prm_report_manufacturers_on_report_id", using: :btree

  create_table "prm_report_product_filters", force: true do |t|
    t.integer  "report_id"
    t.string   "product_id", limit: 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prm_report_product_filters", ["product_id"], name: "product_id", using: :btree
  add_index "prm_report_product_filters", ["report_id"], name: "index_prm_report_product_filters_on_report_id", using: :btree

  create_table "product", primary_key: "id_num", force: true do |t|
    t.string    "id",                  limit: 32,              null: false
    t.string    "name",                limit: 300
    t.string    "model",               limit: 100
    t.float     "csi_score",           limit: 24
    t.float     "functionality_score", limit: 24
    t.float     "reliability_score",   limit: 24
    t.float     "support_score",       limit: 24
    t.string    "manufacturer",        limit: 32
    t.timestamp "last_update",                                 null: false
    t.integer   "all_reviews_count"
    t.integer   "func_reviews_count"
    t.integer   "sup_review_count"
    t.integer   "rel_reviews_count"
    t.integer   "nps_score",                       default: 0
  end

  add_index "product", ["id"], name: "product_id_index", unique: true, using: :btree
  add_index "product", ["manufacturer"], name: "FKED8DCCEF6272C30E", using: :btree
  add_index "product", ["name"], name: "idx_product_name", using: :btree

  create_table "product_category", id: false, force: true do |t|
    t.string  "product_id",  limit: 32, null: false
    t.integer "category_id"
  end

  add_index "product_category", ["category_id"], name: "FK_pc_category", using: :btree
  add_index "product_category", ["product_id"], name: "FK_pc_product", using: :btree

  create_table "product_groupings", force: true do |t|
    t.integer  "product_group_id"
    t.string   "product_id",       limit: 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_groups", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "one_product_group"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "keywords"
    t.text     "aggregates"
    t.text     "trending_report_settings"
    t.text     "psa_report_settings"
  end

  create_table "retailer_site", force: true do |t|
    t.string "url",         limit: 3000, null: false
    t.string "description", limit: 500
  end

  create_table "retailer_site_product", id: false, force: true do |t|
    t.string "product_id",       limit: 32, null: false
    t.string "retailer_site_id", limit: 32, null: false
  end

  add_index "retailer_site_product", ["product_id"], name: "FKA69AC2E632D1FBDE", using: :btree
  add_index "retailer_site_product", ["product_id"], name: "FKA69AC2E64977A86E", using: :btree
  add_index "retailer_site_product", ["retailer_site_id"], name: "FKA69AC2E63F76EB17", using: :btree
  add_index "retailer_site_product", ["retailer_site_id"], name: "FKA69AC2E6FF369887", using: :btree

  create_table "review", force: true do |t|
    t.string   "product_id",          limit: 32,   null: false
    t.date     "last_update_date"
    t.string   "title",               limit: 300
    t.float    "csi_score",           limit: 24
    t.float    "reliability_score",   limit: 24
    t.string   "reviewer_name",       limit: 100
    t.float    "functionality_score", limit: 24
    t.string   "site",                limit: 100
    t.string   "reviewer_email",      limit: 100
    t.string   "reviewer_country",    limit: 2
    t.string   "source_url",          limit: 3000
    t.datetime "recieve_date"
    t.string   "reviewer_state",      limit: 20
    t.text     "text"
    t.string   "reviewer_city",       limit: 100
    t.float    "support_score",       limit: 24
    t.datetime "sync_date"
    t.string   "visibility",          limit: 1
    t.integer  "cust_score",          limit: 1
  end

  add_index "review", ["functionality_score"], name: "idx_f_score", using: :btree
  add_index "review", ["product_id"], name: "FKC84EF75832D1FBDE", using: :btree
  add_index "review", ["product_id"], name: "FKC84EF7584977A86E", using: :btree
  add_index "review", ["reliability_score"], name: "idx_r_score", using: :btree
  add_index "review", ["reviewer_country"], name: "FKC84EF75858DC7376", using: :btree
  add_index "review", ["reviewer_country"], name: "FKC84EF7586F822006", using: :btree
  add_index "review", ["support_score"], name: "idx_s_score", using: :btree

  create_table "review_audit", force: true do |t|
    t.datetime "audit_date",                              null: false
    t.string   "csi_score_comment",           limit: 500
    t.string   "functionality_score_comment", limit: 500
    t.float    "new_csi_score",               limit: 24
    t.float    "new_functionality_score",     limit: 24
    t.float    "new_reliability_score",       limit: 24
    t.float    "new_support_score",           limit: 24
    t.integer  "oem_user_id",                             null: false
    t.float    "old_csi_score",               limit: 24
    t.float    "old_functionality_score",     limit: 24
    t.float    "old_reliability_score",       limit: 24
    t.float    "old_support_score",           limit: 24
    t.string   "reliability_score_comment",   limit: 500
    t.string   "review_id",                   limit: 32,  null: false
    t.string   "support_score_comment",       limit: 500
  end

  add_index "review_audit", ["id"], name: "id", unique: true, using: :btree

  create_table "review_feedback", force: true do |t|
    t.string    "review_id",         limit: 32,   null: false
    t.integer   "oem_user_id"
    t.string    "feedback",          limit: 4000, null: false
    t.integer   "tag_functionality"
    t.integer   "tag_reliability"
    t.integer   "tag_support"
    t.string    "disclaimer",        limit: 1
    t.timestamp "feedback_time",                  null: false
  end

  add_index "review_feedback", ["oem_user_id"], name: "oem_user_id", using: :btree
  add_index "review_feedback", ["review_id"], name: "review_id", using: :btree

  create_table "review_updates", force: true do |t|
    t.integer  "product_id"
    t.datetime "last_updated_at"
    t.integer  "number_of_reviews"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "review_updates", ["product_id"], name: "index_review_updates_on_product_id", using: :btree

  create_table "role", force: true do |t|
    t.string "name"
  end

  add_index "role", ["id"], name: "id", unique: true, using: :btree

  create_table "sent_reports", force: true do |t|
    t.integer  "user_id"
    t.integer  "usage_id"
    t.string   "usage_type"
    t.datetime "sent_at"
    t.string   "output_format"
    t.boolean  "complimentary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "category_type"
  end

  create_table "statistic", force: true do |t|
    t.string    "name",       limit: 50,  null: false
    t.integer   "value_int"
    t.string    "value_str",  limit: 200
    t.timestamp "value_date"
  end

  create_table "user_action", force: true do |t|
    t.string   "visitor_profile_id", limit: 36
    t.datetime "action_time"
    t.string   "page_name",          limit: 100
    t.string   "ip_address",         limit: 30
    t.string   "referrer",           limit: 300
    t.string   "action_name",        limit: 50
    t.string   "action_param1",      limit: 300
    t.string   "action_param2",      limit: 100
    t.string   "action_param3",      limit: 100
  end

  create_table "user_logins", force: true do |t|
    t.integer  "user_id"
    t.string   "login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                        null: false
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token", limit: 20
    t.string   "remember_token",       limit: 20
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                  default: 0
    t.string   "unlock_token",         limit: 20
    t.datetime "locked_at"
    t.string   "authentication_token", limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name",            limit: 100
    t.string   "first_name",           limit: 100
    t.string   "company"
    t.boolean  "send_review_updates"
    t.text     "unconfirmed_email"
  end

  create_table "visitor", force: true do |t|
    t.string  "ua_name"
    t.string  "ua_platform"
    t.string  "ua_version"
    t.integer "oem_user_id"
  end

  add_index "visitor", ["id"], name: "id", unique: true, using: :btree

  create_table "wom_requests", force: true do |t|
    t.integer  "user_id"
    t.string   "product_name"
    t.string   "competitor_a"
    t.string   "competitor_b"
    t.string   "competitor_c"
    t.string   "competitor_d"
    t.string   "update_frequency"
    t.string   "email"
    t.string   "company_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
