class CreateUserLogins < ActiveRecord::Migration
  def self.up
    create_table :user_logins do |t|
      t.integer :id
      t.integer :user_id
      t.string :login

      t.timestamps
    end
  end

  def self.down
    drop_table :user_logins
  end
end
