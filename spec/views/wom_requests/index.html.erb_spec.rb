require 'spec_helper'

describe "/wom_requests/index.html.erb" do
  include WomRequestsHelper

  before(:each) do
    assigns[:wom_requests] = [
      stub_model(WomRequest,
        :user_id => 1,
        :product_name => "value for product_name",
        :competitor_a => "value for competitor_a",
        :competitor_b => "value for competitor_b",
        :competitor_c => "value for competitor_c",
        :competitor_d => "value for competitor_d",
        :update_frequency => "value for update_frequency",
        :email => "value for email",
        :company_name => "value for company_name"
      ),
      stub_model(WomRequest,
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
    ]
  end

#  it "renders a list of wom_requests" do
#    render
#    response.should have_tag("tr>td", 1.to_s, 2)
#    response.should have_tag("tr>td", "value for product_name".to_s, 2)
#    response.should have_tag("tr>td", "value for competitor_a".to_s, 2)
#    response.should have_tag("tr>td", "value for competitor_b".to_s, 2)
#    response.should have_tag("tr>td", "value for competitor_c".to_s, 2)
#    response.should have_tag("tr>td", "value for competitor_d".to_s, 2)
#    response.should have_tag("tr>td", "value for update_frequency".to_s, 2)
#    response.should have_tag("tr>td", "value for email".to_s, 2)
#    response.should have_tag("tr>td", "value for company_name".to_s, 2)
#  end
end
