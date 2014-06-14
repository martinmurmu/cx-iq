class CreateReportManufacturers < ActiveRecord::Migration
  def self.up
    create_table :report_manufacturers do |t|
      t.integer :report_id
      t.string :manufacturer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :report_manufacturers
  end
end
