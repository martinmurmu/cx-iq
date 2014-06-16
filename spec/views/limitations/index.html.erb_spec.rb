#require 'spec_helper'
#
#describe "/limitations/index.html.erb" do
#  include LimitationsHelper
#
#  before(:each) do
#    assigns[:limitations] = [
#      stub_model(Limitation,
#        :user_id => 1,
#        :my_lists => 1,
#        :products_per_list => 1,
#        :prm_reports => 1
#      ),
#      stub_model(Limitation,
#        :user_id => 1,
#        :my_lists => 1,
#        :products_per_list => 1,
#        :prm_reports => 1
#      )
#    ]
#  end
#
#  it "renders a list of limitations" do
#    render
#    response.should have_tag("tr>td", 1.to_s, 2)
#    response.should have_tag("tr>td", 1.to_s, 2)
#    response.should have_tag("tr>td", 1.to_s, 2)
#    response.should have_tag("tr>td", 1.to_s, 2)
#  end
#end
