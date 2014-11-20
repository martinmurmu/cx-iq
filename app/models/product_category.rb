class ProductCategory < ActiveRecord::Base
  self.table_name = "product_category"
  belongs_to :category, :foreign_key => 'category_id'
  belongs_to :product, :foreign_key => 'product_id'
end
