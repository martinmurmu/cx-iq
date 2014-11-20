class ReportManufacturer < ActiveRecord::Base
  self.table_name = "prm_report_manufacturers"
  
  belongs_to :product_report, :foreign_key => 'report_id'
  belongs_to :manufacturer, :foreign_key => 'manufacturer_id'
end
