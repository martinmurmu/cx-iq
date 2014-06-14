class AddPerPageToProductReports < ActiveRecord::Migration
  def self.up
    add_column :product_reports, :per_page, :integer
  end

  def self.down
    remove_column :product_reports, :per_page
  end
end
