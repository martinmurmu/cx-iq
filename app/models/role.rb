class Role < ActiveRecord::Base
  set_table_name "role"

  has_many :users, :through => :oem_user_role
  
end
