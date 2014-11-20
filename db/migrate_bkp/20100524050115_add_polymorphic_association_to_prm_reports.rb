class AddPolymorphicAssociationToPrmReports < ActiveRecord::Migration
  def self.up
    add_column :prm_product_reports, :product_category_type, :string
    ProductReport.all.each{ |pr|
      pr.update_attribute('product_category_type', 'Category')
    }
  end

  def self.down
    remove_column :prm_product_reports, :product_category_type
  end
end
