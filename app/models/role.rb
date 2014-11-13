class Role < ActiveRecord::Base
 self.table_name = "role"

  has_many :users, :through => :oem_user_role
  
end
