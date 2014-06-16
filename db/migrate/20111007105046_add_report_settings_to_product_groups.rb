class AddReportSettingsToProductGroups < ActiveRecord::Migration
  def self.up
    add_column :product_groups, :trending_report_settings, :text
    add_column :product_groups, :psa_report_settings, :text
  end

  def self.down
    remove_column :product_groups, :psa_report_settings
    remove_column :product_groups, :trending_report_settings
  end
end
