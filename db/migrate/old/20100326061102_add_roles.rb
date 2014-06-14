class AddRoles < ActiveRecord::Migration
  def self.up
    create_table "role", :force => true do |t|
      t.string "name"
    end

    add_index "role", ["id"], :name => "id", :unique => true

    create_table "oem_user_role", :id => false, :force => true do |t|
      t.integer "oem_user_id", :null => false
      t.integer "role_id",     :null => false
    end

    add_index "oem_user_role", ["oem_user_id"], :name => "FK94C31B822AD395FD"
    add_index "oem_user_role", ["role_id"], :name => "FK94C31B82BC63A9D1"
  end

  def self.down
  end
end
