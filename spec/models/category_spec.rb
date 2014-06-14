require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  
  fixtures :category, :product, :product_category
  
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :parent_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Category.create!(@valid_attributes)
  end
  
  it "should know the top level master category" do
    Category.root.should == category(:master)
  end
  
  it "should know its' sub-categories" do
    category(:master).children.should == [category(:cameras),category(:computers),category(:portables)]
  end

  it "should know its' parent" do
    category(:master).parent.should be_nil
    category(:cameras).parent.should == category(:master)
    category(:computer_accessories).parent.should == category(:computers)
  end
  
  it "should know all its' ancestors" do
    category(:master).ancestors.should == []
    category(:cameras).ancestors.should == [category(:master)]
    category(:computer_accessories).ancestors.should == [category(:computers), category(:master)]
  end
  
  it "should know if it's root or not" do
    category(:master).is_root?.should be_true
    category(:cameras).is_root?.should_not be_true   
  end
  
  describe 'number_of_product_reviews' do
    it 'should return number of all products reviews' do
      #category(:computer_accessories).number_of_product_reviews.should == 24
    end
  end
  
  describe 'nodes connectivity' do
    it "should update nodes" do
      Category.delete_all
      a = Factory(:category, :parent_id => nil)
      b = Factory(:category, :parent_id => a.id)
      c = Factory(:category, :parent_id => a.id)
      d = Factory(:category, :parent_id => b.id)
      e = Factory(:category, :parent_id => b.id)
      Category.root.update_node_attributes(1)
      
      Category.find(a.id).attrib_left.should == 1
      Category.find(a.id).attrib_right.should == 10
      
      Category.find(e.id).attrib_left.should == 5
      Category.find(e.id).attrib_right.should == 6
    end
  end
  
end
