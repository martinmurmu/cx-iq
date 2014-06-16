require 'spec_helper'

describe CategorySubscription do
  before(:each) do
    @valid_attributes = {
      :category_id => 1,
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    CategorySubscription.create!(@valid_attributes)
  end
end
