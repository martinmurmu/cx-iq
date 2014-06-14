require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/products/edit.html.erb" do
  include ProductsHelper

  before(:each) do
    assigns[:product] = @product = stub_model(Product,
      :new_record? => false,
      :name => "value for name",
      :model => "value for model",
      :csi_score => 1.5,
      :functionality_score => 1.5,
      :reliability_score => 1.5,
      :support_score => 1.5,
      :manufacturer => "value for manufacturer"
    )
  end

  it "renders the edit product form" do
    render

    response.should have_tag("form[action=#{product_path(@product)}][method=post]") do
      with_tag('input#product_name[name=?]', "product[name]")
      with_tag('input#product_model[name=?]', "product[model]")
      with_tag('input#product_csi_score[name=?]', "product[csi_score]")
      with_tag('input#product_functionality_score[name=?]', "product[functionality_score]")
      with_tag('input#product_reliability_score[name=?]', "product[reliability_score]")
      with_tag('input#product_support_score[name=?]', "product[support_score]")
      with_tag('input#product_manufacturer[name=?]', "product[manufacturer]")
    end
  end
end
