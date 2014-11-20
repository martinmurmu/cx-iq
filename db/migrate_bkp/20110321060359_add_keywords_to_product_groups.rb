class AddKeywordsToProductGroups < ActiveRecord::Migration
  def self.up
    add_column :product_groups, :keywords, :text
  end

  def self.down
    remove_column :product_groups, :keywords
  end
end
