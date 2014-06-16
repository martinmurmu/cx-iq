require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Product do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :model => "value for model",
      :csi_score => 1.5,
      :functionality_score => 1.5,
      :reliability_score => 1.5,
      :support_score => 1.5,
      :last_update => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Product.create!(@valid_attributes)
  end
  
  it 'should normally be valid' do
    Factory.build(:product).should be_valid
  end
  
end
