class CreateLimitations < ActiveRecord::Migration
  def self.up
    create_table :limitations do |t|
      t.integer :user_id
      t.integer :my_lists
      t.integer :products_per_list
      t.integer :prm_reports

      t.timestamps
    end
  end

  def self.down
    drop_table :limitations
  end
end
