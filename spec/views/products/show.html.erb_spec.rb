require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/products/show.html.erb" do
  include ProductsHelper
  before(:each) do
    assigns[:product] = @product = stub_model(Product,
      :name => "value for name",
      :model => "value for model",
      :csi_score => 1.5,
      :functionality_score => 1.5,
      :reliability_score => 1.5,
      :support_score => 1.5,
      :manufacturer => "value for manufacturer"
    )
  end

  # it "renders attributes in <p>" do
  #   render
  #   response.should have_text(/value\ for\ name/)
  #   response.should have_text(/value\ for\ model/)
  #   response.should have_text(/1\.5/)
  #   response.should have_text(/1\.5/)
  #   response.should have_text(/1\.5/)
  #   response.should have_text(/1\.5/)
  #   response.should have_text(/value\ for\ manufacturer/)
  # end          
end
