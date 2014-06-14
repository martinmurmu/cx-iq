require 'spec_helper'

describe "/limitations/edit.html.erb" do
  include LimitationsHelper

  before(:each) do
    assigns[:limitation] = @limitation = stub_model(Limitation,
      :new_record? => false,
      :user_id => 1,
      :my_lists => 1,
      :products_per_list => 1,
      :prm_reports => 1
    )
  end

  it "renders the edit limitation form" do
    render

    response.should have_tag("form[action=#{limitation_path(@limitation)}][method=post]") do
      with_tag('input#limitation_user_id[name=?]', "limitation[user_id]")
      with_tag('input#limitation_my_lists[name=?]', "limitation[my_lists]")
      with_tag('input#limitation_products_per_list[name=?]', "limitation[products_per_list]")
      with_tag('input#limitation_prm_reports[name=?]', "limitation[prm_reports]")
    end
  end
end
