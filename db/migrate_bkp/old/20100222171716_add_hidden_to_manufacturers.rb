class AddHiddenToManufacturers < ActiveRecord::Migration
  def self.up
    add_column :manufacturer, :hidden, :integer
  end

  def self.down
    remove_column :manufacturer, :hidden, :integer
  end
end
