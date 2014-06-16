class RenamingTables < ActiveRecord::Migration
  def self.up
    rename_table :product_reports, :prm_product_reports
    rename_table :report_manufacturers, :prm_report_manufacturers
    rename_table :report_product_filters, :prm_report_product_filters
    rename_table :category_subscriptions, :prm_category_subscriptions
    rename_table :delayed_jobs, :prm_delayed_jobs
  end

  def self.down
    rename_table :prm_delayed_jobs, :delayed_jobs
    rename_table :prm_category_subscriptions, :category_subscriptions
    rename_table :prm_report_product_filters, :report_product_filters
    rename_table :prm_report_manufacturers, :report_manufacturers
    rename_table :prm_product_reports, :product_reports
  end
end
