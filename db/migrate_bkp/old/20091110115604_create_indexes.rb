class CreateIndexes < ActiveRecord::Migration
  def self.up
    #remove_index :product_reports, :id
    add_index :prm_product_reports, :id
    
    add_index :prm_category_subscriptions, :id
    add_index :prm_category_subscriptions, :user_id
   
    
    add_index :prm_product_reports, :user_id
    add_index :prm_report_manufacturers, :report_id
    add_index :prm_report_product_filters, :report_id
    
  end

  def self.down
    add_index :prm_product_reports, :id 
    remove_index :prm_product_reports, :id
    
    remove_index :prm_report_product_filters, :report_id
    remove_index :prm_report_manufacturers, :report_id

    remove_index :prm_product_reports, :user_id
    remove_index :prm_category_subscriptions, :id
    remove_index :prm_category_subscriptions, :user_id
  end
end
