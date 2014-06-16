require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Review do
  before(:each) do
    @valid_attributes = {
      :product_id => 1,
      :last_update_date => Date.today,
      :title => "value for title",
      :csi_score => 1.5,
      :reliability_score => 1.5,
      :reviewer_name => "value for reviewer_name",
      :functionality_score => 1.5,
      :site => "value for site",
      :reviewer_email => "value for reviewer_email",
      :reviewer_country => "value for reviewer_country",
      :source_url => "value for source_url",
      :recieve_date => Time.now,
      :reviewer_state => "value for reviewer_state",
      :text => "value for text",
      :reviewer_city => "value for reviewer_city",
      :support_score => 1.5,
      :visibility => "value for visibility"
    }
  end

  it "should create a new instance given valid attributes" do
    Review.create!(@valid_attributes)
  end
end
