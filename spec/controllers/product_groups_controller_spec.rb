require 'spec_helper'

describe ProductGroupsController do
  fixtures :product_groups, :limitations

  before do
    sign_in users(:quentin)
  end

  def mock_product_group(stubs={})
    @mock_product_group ||= mock_model(ProductGroup, stubs)
  end
  
  describe 'create_from_product_report' do
    it 'finds product report and creates ' do
      mock_report = mock_model(ProductReport, :filtered_products => [])
      mock_product_reports = mock_model(ProductReport)
      mock_product_reports.should_receive(:find).with('37').and_return(mock_report)
      @controller.current_user.should_receive(:product_reports).and_return(mock_product_reports)
      ProductGroup.should_receive(:create_from_filtered_product_report).with(mock_report, users(:quentin), 'test list 4').and_return product_groups(:one)
      post :create_from_product_report, :report_id => '37', :product_group => {:name => 'test list 4'}
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested product_group" do
        mock_product_groups = mock_model(ProductGroup)
        mock_product_groups.should_receive(:find).with('37').and_return(mock_product_group)
        @controller.current_user.should_receive(:product_groups).and_return(mock_product_groups)

        mock_product_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :product_group => {:these => 'params'}
      end

      it "assigns the requested car as @product_group" do
        ProductGroup.stub(:find).and_return(mock_product_group(:update_attributes => true))
        put :update, :id => "1"
        assigns[:product_group].should equal(mock_product_group)
      end

      it "redirects to the product_group" do
        ProductGroup.stub(:find).and_return(mock_product_group(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(product_groups_url)
      end
    end

    describe "with invalid params" do
      it "updates the requested product_group" do
        mock_product_groups = mock_model(ProductGroup)
        mock_product_groups.should_receive(:find).with('37').and_return(mock_product_group)
        @controller.current_user.should_receive(:product_groups).and_return(mock_product_groups)

        mock_product_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :product_group => {:these => 'params'}
      end

      it "assigns the car as @product_group" do
        ProductGroup.stub(:find).and_return(mock_product_group(:update_attributes => false))
        put :update, :id => "1"
        assigns[:product_group].should equal(mock_product_group)
      end

      it "re-renders the 'edit' template" do
        ProductGroup.stub(:find).and_return(mock_product_group(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

end
