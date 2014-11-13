class OemUser < ActiveRecord::Base
  self.table_name = "oem_user"
  has_many :roles, :through => :oem_user_role
  

end
