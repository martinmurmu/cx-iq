class OemUser < ActiveRecord::Base
  set_table_name "oem_user"
  has_many :roles, :through => :oem_user_role
  

end