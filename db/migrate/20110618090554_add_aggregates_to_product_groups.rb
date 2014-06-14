class AddAggregatesToProductGroups < ActiveRecord::Migration
  def self.up
    add_column :product_groups, :aggregates, :text
  end

  def self.down
    remove_column :product_groups, :aggregates
  end
end
