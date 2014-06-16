require 'spec_helper'

describe SentReport do
  before(:each) do
    @valid_attributes = {
      :user_id => 1
    }
  end

  it 'should normally be valid' do
    Factory.build(:sent_report).should be_valid
  end

  describe 'polymorphic association to groups of products' do
    it 'may belong to category' do
      group = Factory(:category)
      pr = Factory(:sent_report, :category => group)
      pr = SentReport.find :last
      pr.category.should == group
    end
    it 'may belong to product group' do
      group = Factory(:category)
      pr = Factory(:sent_report, :category => group)
      pr = SentReport.find :last
      pr.category.should == group
    end
  end

end
