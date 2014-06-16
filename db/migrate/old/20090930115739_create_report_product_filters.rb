class CreateReportProductFilters < ActiveRecord::Migration
  def self.up
    create_table :report_product_filters do |t|
      t.integer :report_id
      t.string :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :report_product_filters
  end
end
