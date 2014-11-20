class AddFilteredFieldToProductReports < ActiveRecord::Migration
  def self.up
    add_column :product_reports, :filtered, :boolean
  end

  def self.down
    remove_column :product_reports, :filtered 
  end
end
