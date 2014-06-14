require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/product_reports/new.html.erb" do
  include ProductReportsHelper

  before(:each) do
    assigns[:product_report] = stub_model(ProductReport,
      :new_record? => true,
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
    assigns[:categories] = [mock('Category', :manufacturers => [], :name => "TVs", :id => 1)]
  end

  it "renders new product_report form" do
    render

    response.should have_tag("form[action=?][method=post]", product_reports_path) do
      with_tag("select#product_report_product_category_id[name=?]", "product_report[product_category_id]")
      with_tag("select#report_manufacturer_ids[name=?]", "report_manufacturer_ids[]")
      with_tag("select#product_report_sorting_field[name=?]", "product_report[sorting_field]")
      with_tag("select#product_report_sorting_order[name=?]", "product_report[sorting_order]")
      with_tag("select#product_report_number_of_reviews[name=?]", "product_report[number_of_reviews]")
      with_tag("select#product_report_csi_range[name=?]", "product_report[csi_range]")
      with_tag("select#product_report_pfs_range[name=?]", "product_report[pfs_range]")
      with_tag("select#product_report_prs_range[name=?]", "product_report[prs_range]")
      with_tag("select#product_report_pss_range[name=?]", "product_report[pss_range]")
    end
  end
end
