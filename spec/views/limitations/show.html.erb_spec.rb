require 'spec_helper'

describe "/limitations/show.html.erb" do
  include LimitationsHelper
  before(:each) do
    assigns[:limitation] = @limitation = stub_model(Limitation,
      :user_id => 1,
      :my_lists => 1,
      :products_per_list => 1,
      :prm_reports => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
