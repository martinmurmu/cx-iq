class CreateProductGroupings < ActiveRecord::Migration
  def self.up
    create_table :product_groupings do |t|
      t.integer :product_group_id
      t.string :product_id,  :limit => 32

      t.timestamps
    end
  end

  def self.down
    drop_table :product_groupings
  end
end
