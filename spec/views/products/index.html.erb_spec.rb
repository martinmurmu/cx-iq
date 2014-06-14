require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/products/index.html.erb" do
  include ProductsHelper

  before(:each) do
    assigns[:products] = [
      stub_model(Product,
        :name => "value for name",
        :model => "value for model",
        :csi_score => 1.5,
        :functionality_score => 1.5,
        :reliability_score => 1.5,
        :support_score => 1.5,
        :manufacturer => "value for manufacturer"
      ),
      stub_model(Product,
        :name => "value for name",
        :model => "value for model",
        :csi_score => 1.5,
        :functionality_score => 1.5,
        :reliability_score => 1.5,
        :support_score => 1.5,
        :manufacturer => "value for manufacturer"
      )
    ]
  end

  # it "renders a list of products" do
  #   render
  #   response.should have_tag("tr>td", "value for name".to_s, 2)
  #   response.should have_tag("tr>td", "value for model".to_s, 2)
  #   response.should have_tag("tr>td", 1.5.to_s, 2)
  #   response.should have_tag("tr>td", 1.5.to_s, 2)
  #   response.should have_tag("tr>td", 1.5.to_s, 2)
  #   response.should have_tag("tr>td", 1.5.to_s, 2)
  #   response.should have_tag("tr>td", "value for manufacturer".to_s, 2)
  # end     
end
