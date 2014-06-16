require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/manufacturers/show.html.erb" do
  include ManufacturersHelper
  before(:each) do
    assigns[:manufacturer] = @manufacturer = stub_model(Manufacturer,
      :name => "value for name"
    )
  end

#  it "renders attributes in <p>" do
#    render
#    response.should have_text(/value\ for\ name/)
#  end
end
