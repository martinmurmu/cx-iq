require 'spec_helper'

describe "/wom_requests/edit.html.erb" do
  include WomRequestsHelper

  before(:each) do
    assigns[:wom_request] = @wom_request = stub_model(WomRequest,
      :new_record? => false,
      :user_id => 1,
      :product_name => "value for product_name",
      :competitor_a => "value for competitor_a",
      :competitor_b => "value for competitor_b",
      :competitor_c => "value for competitor_c",
      :competitor_d => "value for competitor_d",
      :update_frequency => "value for update_frequency",
      :email => "value for email",
      :company_name => "value for company_name"
    )
  end

#  it "renders the edit wom_request form" do
#    render
#
#    response.should have_tag("form[action=#{wom_request_path(@wom_request)}][method=post]") do
#      with_tag('input#wom_request_user_id[name=?]', "wom_request[user_id]")
#      with_tag('input#wom_request_product_name[name=?]', "wom_request[product_name]")
#      with_tag('input#wom_request_competitor_a[name=?]', "wom_request[competitor_a]")
#      with_tag('input#wom_request_competitor_b[name=?]', "wom_request[competitor_b]")
#      with_tag('input#wom_request_competitor_c[name=?]', "wom_request[competitor_c]")
#      with_tag('input#wom_request_competitor_d[name=?]', "wom_request[competitor_d]")
#      with_tag('input#wom_request_update_frequency[name=?]', "wom_request[update_frequency]")
#      with_tag('input#wom_request_email[name=?]', "wom_request[email]")
#      with_tag('input#wom_request_company_name[name=?]', "wom_request[company_name]")
#    end
#  end
end
