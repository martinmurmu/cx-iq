class ProductGrouping < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_group

end
