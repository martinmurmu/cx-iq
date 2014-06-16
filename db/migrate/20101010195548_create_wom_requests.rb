class CreateWomRequests < ActiveRecord::Migration
  def self.up
    create_table :wom_requests do |t|
      t.integer :user_id
      t.string :product_name
      t.string :competitor_a
      t.string :competitor_b
      t.string :competitor_c
      t.string :competitor_d
      t.string :update_frequency
      t.string :email
      t.string :company_name

      t.timestamps
    end
  end

  def self.down
    drop_table :wom_requests
  end
end
