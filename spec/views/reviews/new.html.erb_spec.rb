require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reviews/new.html.erb" do
  include ReviewsHelper

  before(:each) do
    assigns[:review] = stub_model(Review,
      :new_record? => true,
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
    assigns[:product] = stub_model(Product)
    assigns[:current_user] = stub_model(User)
  end

  it "renders new review form" do
    render

    response.should have_tag("form[action=?][method=post]", reviews_path) do
      with_tag("input#review_product_id[name=?]", "review[product_id]")
      with_tag("input#review_csi_score[name=?]", "review[csi_score]")
      with_tag("input#review_reviewer_name[name=?]", "review[reviewer_name]")
    end
  end
end
