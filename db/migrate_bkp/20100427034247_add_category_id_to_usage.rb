class AddCategoryIdToUsage < ActiveRecord::Migration
  def self.up
    add_column :sent_reports, :category_id, :integer
  end

  def self.down
    remove_column :sent_reports, :category_id
  end
end
