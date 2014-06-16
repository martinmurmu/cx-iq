require 'spec_helper'

describe "/limitations/new.html.erb" do
  include LimitationsHelper

  before(:each) do
    assigns[:limitation] = stub_model(Limitation,
      :new_record? => true,
      :user_id => 1,
      :my_lists => 1,
      :products_per_list => 1,
      :prm_reports => 1
    )
  end

  it "renders new limitation form" do
    render

    response.should have_tag("form[action=?][method=post]", limitations_path) do
      with_tag("input#limitation_user_id[name=?]", "limitation[user_id]")
      with_tag("input#limitation_my_lists[name=?]", "limitation[my_lists]")
      with_tag("input#limitation_products_per_list[name=?]", "limitation[products_per_list]")
      with_tag("input#limitation_prm_reports[name=?]", "limitation[prm_reports]")
    end
  end
end
