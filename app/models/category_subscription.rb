class CategorySubscription < ActiveRecord::Base
  set_table_name "prm_category_subscriptions"
  belongs_to :user
  belongs_to :category
end
