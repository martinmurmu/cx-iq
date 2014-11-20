class CreateUserMessages < ActiveRecord::Migration
  def self.up
    create_table :user_messages do |t|
      t.string :name
      t.string :email
      t.string :company
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :user_messages
  end
end
