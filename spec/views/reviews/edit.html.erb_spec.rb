require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reviews/edit.html.erb" do
  include ReviewsHelper

  before(:each) do
    assigns[:review] = @review = stub_model(Review,
      :new_record? => false,
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

  it "renders the edit review form" do
    render

    response.should have_tag("form[action=#{review_path(@review)}][method=post]") do
      with_tag('input#review_product_id[name=?]', "review[product_id]")
      with_tag('input#review_title[name=?]', "review[title]")
      with_tag('input#review_csi_score[name=?]', "review[csi_score]")
      with_tag('input#review_reliability_score[name=?]', "review[reliability_score]")
      with_tag('input#review_reviewer_name[name=?]', "review[reviewer_name]")
      with_tag('input#review_functionality_score[name=?]', "review[functionality_score]")
      with_tag('input#review_site[name=?]', "review[site]")
      with_tag('input#review_reviewer_email[name=?]', "review[reviewer_email]")
      with_tag('input#review_reviewer_country[name=?]', "review[reviewer_country]")
      with_tag('input#review_source_url[name=?]', "review[source_url]")
      with_tag('input#review_reviewer_state[name=?]', "review[reviewer_state]")
      with_tag('textarea#review_text[name=?]', "review[text]")
      with_tag('input#review_reviewer_city[name=?]', "review[reviewer_city]")
      with_tag('input#review_support_score[name=?]', "review[support_score]")
      with_tag('input#review_visibility[name=?]', "review[visibility]")
    end
  end
end
