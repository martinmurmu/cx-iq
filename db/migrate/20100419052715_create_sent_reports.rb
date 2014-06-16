class CreateSentReports < ActiveRecord::Migration
  def self.up
    create_table :sent_reports do |t|
      t.integer :user_id
      t.references :usage, :polymorphic => true
      t.timestamp :sent_at, :default => nil
      t.string :output_format
      t.boolean :complimentary
      t.timestamps
    end
  end

  def self.down
    drop_table :sent_reports
  end
end
