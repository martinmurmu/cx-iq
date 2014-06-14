require 'spec_helper'

describe ProductGroup do

  fixtures :manufacturer, :product_groups, :product_groupings, :product

  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :name => "value for name"
    }
  end

  it {should belong_to :user}
  it {should have_many :product_groupings}

  it "should create a new instance given valid attributes" do
    ProductGroup.create!(@valid_attributes)
  end

  it 'should normally be valid' do
    Factory.build(:product_group).should be_valid
  end

  it 'should have many manufacturers' do
    product_groups(:one).manufacturers.should == [manufacturer(:sanyo), manufacturer(:smc)]
  end

  describe 'create_from_filtered_product_report' do
    it 'creates product group' do
      product = Factory(:product)
      report = Factory(:product_report)
      filter = Factory(:report_product_filter, :product_report => report, :product => product)

      lambda{
        ProductGroup.create_from_filtered_product_report(report, users(:one), 'test list 1')
      }.should change(ProductGroup, :count).by(1)
    end

    it 'creates product groupings' do
      product = Factory(:product)
      report = Factory(:product_report)
      filter = Factory(:report_product_filter, :product_report => report, :product => product)

      lambda{
        ProductGroup.create_from_filtered_product_report(report, users(:one), 'test list 2')
      }.should change(ProductGrouping, :count).by(1)
    end

  end

end
