class AddPolymorphicAssociationToSentReports < ActiveRecord::Migration
  def self.up
    add_column :sent_reports, :category_type, :string
    SentReport.all.each{ |pr|
      pr.update_attribute('category_type', 'Category')
    }
  end

  def self.down
    remove_column :sent_reports, :category_type
  end
end
