require 'spec_helper'

describe UserMessages do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "value for email",
      :company => "value for company",
      :message => "value for message"
    }
  end

  it "should create a new instance given valid attributes" do
    UserMessages.create!(@valid_attributes)
  end
end
