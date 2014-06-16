require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reviews/show.html.erb" do
  include ReviewsHelper
  before(:each) do
    assigns[:review] = @review = stub_model(Review,
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
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ title/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/value\ for\ reviewer_name/)
    response.should have_text(/1\.5/)
    response.should have_text(/value\ for\ site/)
    response.should have_text(/value\ for\ reviewer_email/)
    response.should have_text(/value\ for\ reviewer_country/)
    response.should have_text(/value\ for\ source_url/)
    response.should have_text(/value\ for\ reviewer_state/)
    response.should have_text(/value\ for\ text/)
    response.should have_text(/value\ for\ reviewer_city/)
    response.should have_text(/1\.5/)
    response.should have_text(/value\ for\ visibility/)
  end
end
