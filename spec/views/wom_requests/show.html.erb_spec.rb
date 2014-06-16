require 'spec_helper'

describe "/wom_requests/show.html.erb" do
  include WomRequestsHelper
  before(:each) do
    assigns[:wom_request] = @wom_request = stub_model(WomRequest,
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

#  it "renders attributes in <p>" do
#    render
#    response.should have_text(/1/)
#    response.should have_text(/value\ for\ product_name/)
#    response.should have_text(/value\ for\ competitor_a/)
#    response.should have_text(/value\ for\ competitor_b/)
#    response.should have_text(/value\ for\ competitor_c/)
#    response.should have_text(/value\ for\ competitor_d/)
#    response.should have_text(/value\ for\ update_frequency/)
#    response.should have_text(/value\ for\ email/)
#    response.should have_text(/value\ for\ company_name/)
#  end
end
