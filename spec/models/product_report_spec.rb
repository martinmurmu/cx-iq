require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProductReport do

  fixtures :category

  before(:each) do
    @valid_attributes = {
      :product_category => category(:mp3_players),
      :manufacturer_id => 1,
      :sorting_field => 1,
      :sorting_order => 1,
      :number_of_reviews => 1,
      :csi_range => 1,
      :pfs_range => 1,
      :prs_range => 1,
      :pss_range => 1,
      :user_id => 1
    }
  end
  
  should_have_many :report_manufacturers
  should_have_many :manufacturers, :through => :report_manufacturers
  should_have_many :report_product_filters
  should_have_many :filtered_products, :through => :report_product_filters
  should_belong_to :product_category
#  should_validate_presence_of :product_category

  it "should create a new instance given valid attributes" do
    ProductReport.create!(@valid_attributes)
  end
  
  it 'should normally be valid' do
    Factory.build(:product_report).should be_valid
  end

  describe 'polymorphic association to groups of products' do
    it 'may belong to category' do
      group = Factory(:category)
      pr = Factory(:product_report, :product_category => group)
      pr = ProductReport.find :last
      pr.product_category.should == group
    end
    it 'may belong to product group' do
      group = Factory(:product_group)
      pr = Factory(:product_report, :product_category => group)
      pr = ProductReport.find :last
      pr.product_category.should == group
    end
  end

  describe 'search' do
    
    it 'should match category' do
    
    end
    
  end
  
  
end
