class ReportProductFilter < ActiveRecord::Base 
  set_table_name "prm_report_product_filters"
  belongs_to :product_report, :foreign_key => 'report_id'
  belongs_to :product, :foreign_key => 'product_id'
  belongs_to :filtered_product, :foreign_key => 'product_id', :class_name => 'Product'

end
