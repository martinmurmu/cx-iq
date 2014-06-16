class CreateProductReports < ActiveRecord::Migration
  def self.up
    create_table :product_reports do |t|
      t.integer :product_category_id
      t.string :manufacturer_id
      t.integer :sorting_field
      t.integer :sorting_order
      t.integer :number_of_reviews
      t.integer :csi_range
      t.integer :pfs_range
      t.integer :prs_range
      t.integer :pss_range
      t.integer :user_id

      t.timestamps
    end
    add_index :product_reports, :id
  end

  def self.down
    drop_table :product_reports
  end
end
