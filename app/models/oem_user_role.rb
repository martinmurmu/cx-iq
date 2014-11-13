class OemUserRole < ActiveRecord::Base
  self.table_name = "oem_user_role"
  belongs_to :user
  belongs_to :role


end
