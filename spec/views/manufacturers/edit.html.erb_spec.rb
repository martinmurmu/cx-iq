require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/manufacturers/edit.html.erb" do
  include ManufacturersHelper

  before(:each) do
    assigns[:manufacturer] = @manufacturer = stub_model(Manufacturer,
      :new_record? => false,
      :name => "value for name"
    )
  end

  it "renders the edit manufacturer form" do
    render

    response.should have_tag("form[action=#{manufacturer_path(@manufacturer)}][method=post]") do
      with_tag('input#manufacturer_name[name=?]', "manufacturer[name]")
    end
  end
end
