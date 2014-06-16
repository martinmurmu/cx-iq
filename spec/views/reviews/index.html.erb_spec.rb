require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reviews/index.html.erb" do
  include ReviewsHelper

  before(:each) do
    assigns[:reviews] = [
      stub_model(Review,
        :product_id => 1,
        :title => "value for title",
        :csi_score => 1.5,
        :reliability_score => 1.5,
        :reviewer_name => "value for reviewer_name",
        :functionality_score => 1.5,
        :site => "value for site",
        :reviewer_email => "value for reviewer_email",
        :reviewer_country => "value for reviewer_country",
        :source_url => "value for source_url",
        :reviewer_state => "value for reviewer_state",
        :text => "value for text",
        :reviewer_city => "value for reviewer_city",
        :support_score => 1.5,
        :visibility => "value for visibility"
      ),
      stub_model(Review,
        :product_id => 1,
        :title => "value for title",
        :csi_score => 1.5,
        :reliability_score => 1.5,
        :reviewer_name => "value for reviewer_name",
        :functionality_score => 1.5,
        :site => "value for site",
        :reviewer_email => "value for reviewer_email",
        :reviewer_country => "value for reviewer_country",
        :source_url => "value for source_url",
        :reviewer_state => "value for reviewer_state",
        :text => "value for text",
        :reviewer_city => "value for reviewer_city",
        :support_score => 1.5,
        :visibility => "value for visibility"
      )
    ]
  end

  # it "renders a list of reviews" do
  #   render
  #   response.should have_tag("tr>td", 1.to_s, 2)
  #   response.should have_tag("tr>td", "value for title".to_s, 2)
  #   response.should have_tag("tr>td", 1.5.to_s, 2)
  #   response.should have_tag("tr>td", 1.5.to_s, 2)
  #   response.should have_tag("tr>td", "value for reviewer_name".to_s, 2)
  #   response.should have_tag("tr>td", 1.5.to_s, 2)
  #   response.should have_tag("tr>td", "value for site".to_s, 2)
  #   response.should have_tag("tr>td", "value for reviewer_email".to_s, 2)
  #   response.should have_tag("tr>td", "value for reviewer_country".to_s, 2)
  #   response.should have_tag("tr>td", "value for source_url".to_s, 2)
  #   response.should have_tag("tr>td", "value for reviewer_state".to_s, 2)
  #   response.should have_tag("tr>td", "value for text".to_s, 2)
  #   response.should have_tag("tr>td", "value for reviewer_city".to_s, 2)
  #   response.should have_tag("tr>td", 1.5.to_s, 2)
  #   response.should have_tag("tr>td", "value for visibility".to_s, 2)
  # end       
end
