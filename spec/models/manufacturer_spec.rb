require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Manufacturer do
  
  fixtures :manufacturer
  
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end
  
  it 'should normally be valid' do
    Factory.build(:manufacturer).should be_valid
  end
  
  it "should create a new instance given valid attributes" do
    Manufacturer.create!(@valid_attributes)
  end
  
  describe "names_by_ids" do
    it "should return hash of ids => names " do
      Manufacturer.names_by_ids([manufacturer(:smc).id, manufacturer(:sony).id]).should == {manufacturer(:smc).id => manufacturer(:smc).name, manufacturer(:sony).id => manufacturer(:sony).name }
    end
    
    it "should omit duplicate ids" do
      Manufacturer.names_by_ids([
                                  manufacturer(:smc).id,
                                  manufacturer(:sony).id,
                                  manufacturer(:smc).id,
                                  manufacturer(:smc).id,
                                  manufacturer(:sony).id
                                ]).should == {manufacturer(:smc).id => manufacturer(:smc).name, manufacturer(:sony).id => manufacturer(:sony).name }
    end
  end
  
end
