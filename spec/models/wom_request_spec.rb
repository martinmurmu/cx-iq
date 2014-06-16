require 'spec_helper'

describe WomRequest do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :product_name => "value for product_name",
      :competitor_a => "value for competitor_a",
      :competitor_b => "value for competitor_b",
      :competitor_c => "value for competitor_c",
      :competitor_d => "value for competitor_d",
      :update_frequency => "value for update_frequency",
      :email => "value for email",
      :company_name => "value for company_name"
    }
  end

  it "should create a new instance given valid attributes" do
    WomRequest.create!(@valid_attributes)
  end
end
