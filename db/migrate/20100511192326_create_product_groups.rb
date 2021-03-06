class CreateProductGroups < ActiveRecord::Migration
  def self.up
    create_table :product_groups do |t|
      t.integer :user_id
      t.string :name
      t.boolean :one_product_group
      t.timestamps
    end
  end

  def self.down
    drop_table :product_groups
  end
end
