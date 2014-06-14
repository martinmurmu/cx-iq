class ReferenceDb < ActiveRecord::Migration
  def self.up
  create_table "auth_token", :primary_key => "token", :force => true do |t|
    t.integer "oem_user_id"
  end

  add_index "auth_token", ["oem_user_id"], :name => "FK8B5E1CA22AD395FD"
  add_index "auth_token", ["token"], :name => "token", :unique => true

  create_table "category", :force => true do |t|
    t.integer "parent_id"
    t.string  "name",           :limit => 150
    t.integer "products_count"
    t.integer "attrib_left"
    t.integer "attrib_right"
  end

  create_table "competing_product", :id => false, :force => true do |t|
    t.integer "oem_user_id",                                :null => false
    t.string  "primary_id",   :limit => 32, :default => "", :null => false
    t.string  "secondary_id", :limit => 32
  end

  add_index "competing_product", ["oem_user_id"], :name => "FKD4970AD4142DE96D"
  add_index "competing_product", ["oem_user_id"], :name => "FKD4970AD42AD395FD"
  add_index "competing_product", ["primary_id"], :name => "FKD4970AD47E57BDEB"
  add_index "competing_product", ["primary_id"], :name => "FKD4970AD494FD6A7B"
  add_index "competing_product", ["secondary_id"], :name => "FKD4970AD4B8254D39"
  add_index "competing_product", ["secondary_id"], :name => "FKD4970AD4CECAF9C9"

  create_table "country", :primary_key => "iso", :force => true do |t|
    t.string "name",           :limit => 80, :default => "", :null => false
    t.string "printable_name", :limit => 80, :default => "", :null => false
  end

  create_table "country_state", :force => true do |t|
    t.string "country_iso", :limit => 2,  :default => "", :null => false
    t.string "short_name",  :limit => 5
    t.string "name",        :limit => 50, :default => "", :null => false
  end

  create_table "login_history", :id => false, :force => true do |t|
    t.integer   "oem_user_id", :null => false
    t.timestamp "login_time",  :null => false
  end

  add_index "login_history", ["oem_user_id"], :name => "FK88A801BE142DE96D"
  add_index "login_history", ["oem_user_id"], :name => "FK88A801BE2AD395FD"

# Could not dump table "logins" because of following StandardError
#   Unknown type 'null' for column 'id'

  create_table "maillist", :force => true do |t|
    t.string "name",        :limit => 50,  :default => "", :null => false
    t.string "description", :limit => 300
  end

  create_table "maillist_member", :force => true do |t|
    t.integer "maillist_id",                                :null => false
    t.string  "email",       :limit => 100, :default => "", :null => false
    t.integer "oem_user_id"
  end

  add_index "maillist_member", ["maillist_id"], :name => "maillist_id"
  add_index "maillist_member", ["oem_user_id"], :name => "mail_member_oem_user_id"

  create_table "manufacturer", :primary_key => "name", :force => true do |t|
    t.string  "id",     :limit => 32, :default => "",    :null => false
    t.boolean "hidden",               :default => false, :null => false
  end

  add_index "manufacturer", ["id"], :name => "id"

  create_table "oem_user", :force => true do |t|
    t.integer "isActive"
    t.string  "phone_num",    :limit => 20
    t.string  "last_name",    :limit => 100
    t.string  "first_name",   :limit => 100
    t.integer "isWidgetDemo"
    t.string  "email",        :limit => 100
    t.string  "company",      :limit => 200
    t.integer "isAdmin"
    t.string  "password",     :limit => 50
    t.string  "username",     :limit => 100, :default => "", :null => false
  end

  add_index "oem_user", ["username"], :name => "idx_username"

  create_table "oem_user_backup", :force => true do |t|
    t.integer "isActive"
    t.string  "phone_num",    :limit => 20
    t.string  "last_name",    :limit => 100
    t.string  "first_name",   :limit => 100
    t.integer "isWidgetDemo"
    t.string  "email",        :limit => 100
    t.string  "company",      :limit => 200
    t.integer "isAdmin"
    t.string  "password",     :limit => 50
    t.string  "username",     :limit => 100, :default => "", :null => false
  end

  create_table "oem_user_product", :id => false, :force => true do |t|
    t.string  "product_id",  :limit => 32, :default => "", :null => false
    t.integer "oem_user_id",                               :null => false
  end

  add_index "oem_user_product", ["oem_user_id"], :name => "FK385BC663142DE96D"
  add_index "oem_user_product", ["oem_user_id"], :name => "FK385BC6632AD395FD"
  add_index "oem_user_product", ["product_id"], :name => "FK385BC66332D1FBDE"
  add_index "oem_user_product", ["product_id"], :name => "FK385BC6634977A86E"

  create_table "oem_user_role", :id => false, :force => true do |t|
    t.integer "oem_user_id", :null => false
    t.integer "role_id",     :null => false
  end

  add_index "oem_user_role", ["oem_user_id"], :name => "FK94C31B822AD395FD"
  add_index "oem_user_role", ["role_id"], :name => "FK94C31B82BC63A9D1"

  create_table "prm_category_subscriptions", :force => true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prm_category_subscriptions", ["category_id"], :name => "category_id"
  add_index "prm_category_subscriptions", ["id"], :name => "index_prm_category_subscriptions_on_id"
  add_index "prm_category_subscriptions", ["user_id"], :name => "index_prm_category_subscriptions_on_user_id"

  create_table "prm_delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prm_product_reports", :force => true do |t|
    t.integer  "product_category_id"
    t.string   "manufacturer_id",     :limit => 32
    t.integer  "sorting_field"
    t.integer  "sorting_order"
    t.integer  "number_of_reviews"
    t.integer  "nps_range"
    t.integer  "csi_range"
    t.integer  "pfs_range"
    t.integer  "prs_range"
    t.integer  "pss_range"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "per_page"
    t.boolean  "filtered"
  end

  add_index "prm_product_reports", ["id"], :name => "index_prm_product_reports_on_id"
  add_index "prm_product_reports", ["manufacturer_id"], :name => "prm_prods_manufacturer_id"
  add_index "prm_product_reports", ["product_category_id"], :name => "product_category_id"
  add_index "prm_product_reports", ["user_id"], :name => "index_prm_product_reports_on_user_id"

  create_table "prm_report_manufacturers", :force => true do |t|
    t.integer  "report_id"
    t.string   "manufacturer_id", :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prm_report_manufacturers", ["manufacturer_id"], :name => "manufacturer_id"
  add_index "prm_report_manufacturers", ["report_id"], :name => "index_prm_report_manufacturers_on_report_id"

  create_table "prm_report_product_filters", :force => true do |t|
    t.integer  "report_id"
    t.string   "product_id", :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prm_report_product_filters", ["product_id"], :name => "product_id"
  add_index "prm_report_product_filters", ["report_id"], :name => "index_prm_report_product_filters_on_report_id"

  create_table "product", :force => true do |t|
    t.string    "name",                :limit => 300
    t.string    "model",               :limit => 100
    t.float     "csi_score"
    t.float     "functionality_score"
    t.float     "reliability_score"
    t.float     "support_score"
    t.string    "manufacturer",        :limit => 32
    t.timestamp "last_update",                        :null => false
    t.integer   "all_reviews_count"
    t.integer   "func_reviews_count"
    t.integer   "sup_review_count"
    t.integer   "rel_reviews_count"
  end

  add_index "product", ["manufacturer"], :name => "FKED8DCCEF6272C30E"
  add_index "product", ["name"], :name => "idx_product_name"

  create_table "product_category", :id => false, :force => true do |t|
    t.string  "product_id",  :limit => 32, :default => "", :null => false
    t.integer "category_id"
  end

  add_index "product_category", ["category_id"], :name => "FK_pc_category"
  add_index "product_category", ["product_id"], :name => "FK_pc_product"

# Could not dump table "products_per_categories" because of following StandardError
#   Unknown type 'null' for column 'name'

  create_table "retailer_site", :force => true do |t|
    t.string "url",         :limit => 3000, :default => "", :null => false
    t.string "description", :limit => 500
  end

  create_table "retailer_site_product", :id => false, :force => true do |t|
    t.string "product_id",       :limit => 32, :default => "", :null => false
    t.string "retailer_site_id", :limit => 32, :default => "", :null => false
  end

  add_index "retailer_site_product", ["product_id"], :name => "FKA69AC2E632D1FBDE"
  add_index "retailer_site_product", ["product_id"], :name => "FKA69AC2E64977A86E"
  add_index "retailer_site_product", ["retailer_site_id"], :name => "FKA69AC2E63F76EB17"
  add_index "retailer_site_product", ["retailer_site_id"], :name => "FKA69AC2E6FF369887"

  create_table "review", :force => true do |t|
    t.string   "product_id",          :limit => 32,   :default => "", :null => false
    t.date     "last_update_date"
    t.string   "title",               :limit => 300
    t.float    "csi_score"
    t.float    "reliability_score"
    t.string   "reviewer_name",       :limit => 100
    t.float    "functionality_score"
    t.string   "site",                :limit => 100
    t.string   "reviewer_email",      :limit => 100
    t.string   "reviewer_country",    :limit => 2
    t.string   "source_url",          :limit => 3000
    t.datetime "recieve_date"
    t.string   "reviewer_state",      :limit => 20
    t.text     "text"
    t.string   "reviewer_city",       :limit => 100
    t.float    "support_score"
    t.datetime "sync_date"
    t.string   "visibility",          :limit => 1
  end

  add_index "review", ["functionality_score"], :name => "idx_f_score"
  add_index "review", ["product_id"], :name => "FKC84EF75832D1FBDE"
  add_index "review", ["product_id"], :name => "FKC84EF7584977A86E"
  add_index "review", ["reliability_score"], :name => "idx_r_score"
  add_index "review", ["reviewer_country"], :name => "FKC84EF75858DC7376"
  add_index "review", ["reviewer_country"], :name => "FKC84EF7586F822006"
  add_index "review", ["support_score"], :name => "idx_s_score"

# Could not dump table "review per site" because of following StandardError
#   Unknown type 'null' for column 'site'

  create_table "review_audit", :force => true do |t|
    t.datetime "audit_date",                                                 :null => false
    t.string   "csi_score_comment",           :limit => 500
    t.string   "functionality_score_comment", :limit => 500
    t.float    "new_csi_score"
    t.float    "new_functionality_score"
    t.float    "new_reliability_score"
    t.float    "new_support_score"
    t.integer  "oem_user_id",                                                :null => false
    t.float    "old_csi_score"
    t.float    "old_functionality_score"
    t.float    "old_reliability_score"
    t.float    "old_support_score"
    t.string   "reliability_score_comment",   :limit => 500
    t.string   "review_id",                   :limit => 32,  :default => "", :null => false
    t.string   "support_score_comment",       :limit => 500
  end

  add_index "review_audit", ["id"], :name => "review_audit_uk1", :unique => true

  create_table "review_feedback", :force => true do |t|
    t.string    "review_id",         :limit => 32,   :default => "", :null => false
    t.integer   "oem_user_id"
    t.string    "feedback",          :limit => 4000, :default => "", :null => false
    t.integer   "tag_functionality"
    t.integer   "tag_reliability"
    t.integer   "tag_support"
    t.string    "disclaimer",        :limit => 1
    t.timestamp "feedback_time",                                     :null => false
  end

  add_index "review_feedback", ["oem_user_id"], :name => "oem_user_id"
  add_index "review_feedback", ["review_id"], :name => "review_id"

  create_table "role", :force => true do |t|
    t.string "name"
  end

  add_index "role", ["id"], :name => "role_uk1", :unique => true

  create_table "statistic", :force => true do |t|
    t.string    "name",       :limit => 50,  :default => "", :null => false
    t.integer   "value_int"
    t.string    "value_str",  :limit => 200
    t.timestamp "value_date"
  end

  create_table "user_action", :force => true do |t|
    t.string   "visitor_profile_id", :limit => 36
    t.datetime "action_time"
    t.string   "page_name",          :limit => 100
    t.string   "ip_address",         :limit => 30
    t.string   "referrer",           :limit => 300
    t.string   "action_name",        :limit => 50
    t.string   "action_param1",      :limit => 300
    t.string   "action_param2",      :limit => 100
    t.string   "action_param3",      :limit => 100
  end

  create_table "user_messages", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",    :limit => 40,  :default => "", :null => false
    t.string   "password_salt",                        :default => "", :null => false
    t.string   "confirmation_token",    :limit => 20
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token",  :limit => 20
    t.string   "remember_token",        :limit => 20
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token",          :limit => 20
    t.datetime "locked_at"
    t.string   "authentication_token", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name",             :limit => 100
    t.string   "first_name",            :limit => 100
  end

  create_table "visitor", :force => true do |t|
    t.string  "ua_name"
    t.string  "ua_platform"
    t.string  "ua_version"
    t.integer "oem_user_id"
  end

  add_index "visitor", ["id"], :name => "visitor_uk1", :unique => true

# Could not dump table "visitor analytics" because of following StandardError
#   Unknown type 'null' for column 'Date/Time'
    
  end

  def self.down
    
  end
end
