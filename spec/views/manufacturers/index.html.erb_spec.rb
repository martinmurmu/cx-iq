require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/manufacturers/index.html.erb" do
  include ManufacturersHelper

  before(:each) do
    assigns[:manufacturers] = [
      stub_model(Manufacturer,
        :name => "value for name"
      ),
      stub_model(Manufacturer,
        :name => "value for name"
      )
    ]
  end

  # it "renders a list of manufacturers" do
  #   render
  #   response.should have_tag("tr>td", "value for name".to_s, 2)
  # end   
end
