class AddUnconfirmedEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :unconfirmed_email, :text
  end
end
