class AddUpdateToPrmProductReports < ActiveRecord::Migration
  def self.up
    add_column :prm_product_reports, :last_updated_filter, :integer
  end

  def self.down
    remove_column :prm_product_reports, :last_updated_filter
  end
end
