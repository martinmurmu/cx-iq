require 'spec_helper'

describe ProductGrouping do
  before(:each) do
    @valid_attributes = {
      :product_group_id => 1,
      :product_id => "value for product_id"
    }
  end

  should_belong_to :product
  should_belong_to :product_group  

  it "should create a new instance given valid attributes" do
    ProductGrouping.create!(@valid_attributes)
  end

  it 'should normally be valid' do
    Factory.build(:product_grouping).should be_valid
  end

end
