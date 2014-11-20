class CreatePaperDownloads < ActiveRecord::Migration
  def self.up
    create_table :paper_downloads do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :paper_link

      t.timestamps
    end
  end

  def self.down
    drop_table :paper_downloads
  end
end
