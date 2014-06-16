class WomRequest < ActiveRecord::Base
  validates_presence_of :email
  validates_presence_of :product_name
  validates_presence_of :company_name
end
