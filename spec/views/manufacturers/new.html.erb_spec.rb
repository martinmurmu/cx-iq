require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/manufacturers/new.html.erb" do
  include ManufacturersHelper

  before(:each) do
    assigns[:manufacturer] = stub_model(Manufacturer,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it "renders new manufacturer form" do
    render

    response.should have_tag("form[action=?][method=post]", manufacturers_path) do
      with_tag("input#manufacturer_name[name=?]", "manufacturer[name]")
    end
  end
end
