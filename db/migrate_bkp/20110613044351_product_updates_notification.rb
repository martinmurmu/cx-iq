class ProductUpdatesNotification < ActiveRecord::Migration
  def self.up
    add_column :users, :send_review_updates, :boolean
    create_table :review_updates do |t|
      t.integer :product_id
      t.timestamp :last_updated_at
      t.integer :number_of_reviews

      t.timestamps
    end

    add_index :review_updates, :product_id
  end

  def self.down
    remove_column :users, :send_review_updates
    drop_table :review_updates
  end
end
