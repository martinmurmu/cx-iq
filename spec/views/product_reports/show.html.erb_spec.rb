require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/product_reports/show.html.erb" do
  include ProductReportsHelper
  before(:each) do
    assigns[:product_report] = @product_report = stub_model(ProductReport,
      :product_category_id => 1,
      :manufacturer_id => 1,
      :sorting_field => 1,
      :sorting_order => 1,
      :number_of_reviews => 1,
      :csi_range => 1,
      :pfs_range => 1,
      :prs_range => 1,
      :pss_range => 1,
      :user_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
