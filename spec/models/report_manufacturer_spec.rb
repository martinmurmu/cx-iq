require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportManufacturer do
  before(:each) do
    @valid_attributes = {
      :report_id => 1,
      :manufacturer_id => "value for manufacturer_id"
    }
  end

  it "should create a new instance given valid attributes" do
    ReportManufacturer.create!(@valid_attributes)
  end
end
