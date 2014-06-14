require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportProductFilter do
  before(:each) do
    @valid_attributes = {
      :report_id => 1,
      :product_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ReportProductFilter.create!(@valid_attributes)
  end
end
