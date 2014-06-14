require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProductReportsController do
  fixtures :category
  
  def mock_product_report(stubs={})
    @mock_product_report ||= mock_model(ProductReport, {:[]= => true, :category= => true}.merge(stubs))
  end
  
  before do
    sign_in users(:quentin)
    @controller.stub!(:category_subscription_required).and_return true
    @controller.stub!(:paid_subscription_required).and_return true
  end

  # describe "GET index" do
  #   it "assigns all product_reports as @product_reports" do
  #     ProductReport.stub!(:find).with(:all).and_return([mock_product_report])
  #     get :index
  #     assigns[:product_reports].should == [mock_product_report]
  #   end
  # end
  # 
  # describe "GET show" do
  #   it "assigns the requested product_report as @product_report" do
  #     ProductReport.stub!(:find).with("37").and_return(mock_product_report)
  #     get :show, :id => "37"
  #     assigns[:product_report].should equal(mock_product_report)
  #   end
  # end 

  describe "GET new" do
    it "assigns a new product_report as @product_report" do
      ProductReport.stub!(:new).and_return(mock_product_report)
      get :new
      assigns[:product_report].should equal(mock_product_report)
    end
  end

  describe "GET edit" do
    it "assigns the requested product_report as @product_report" do
      mock_user = mock(User, :guest? => false, :categories => [], :product_groups => [])
      mock_product_reports = mock(ProductReport, :find => mock_product_report)
      @controller.should_receive(:current_user).at_least(:once).and_return(mock_user)
      mock_user.should_receive(:product_reports).and_return(mock_product_reports)
      mock_product_reports.should_receive(:find).with("37").and_return(mock_product_report)
      get :edit, :id => "37"
      assigns[:product_report].should equal(mock_product_report)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created product_report as @product_report" do
        ProductReport.should_receive(:new).with({"user_id"=>users(:quentin).id, "these"=>"params", "product_category_id"=>"10_category"}).and_return(mock_product_report(:save => true))
        post :create, :product_report => {:these => 'params', :product_category_id=> '10_category'}
        assigns[:product_report].should equal(mock_product_report)
      end

      it "redirects to the created product_report" do
        ProductReport.stub!(:new).and_return(mock_product_report(:save => true))
        post :create, :product_report => {:product_category_id=> '10_category'}
        response.should redirect_to(product_report_products_url(mock_product_report))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved product_report as @product_report" do
        ProductReport.should_receive(:new).with({"user_id"=>users(:quentin).id, "these"=>"params", "product_category_id"=>"10_category"}).and_return(mock_product_report(:save => false))
        post :create, :product_report => {:these => 'params', :product_category_id=> '10_category'}
        assigns[:product_report].should equal(mock_product_report)
      end

      it "re-renders the 'new' template" do
        ProductReport.stub!(:new).and_return(mock_product_report(:save => false))
        post :create, :product_report => {:product_category_id=> '10_category'}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested product_report" do
        ProductReport.should_receive(:find).with("37", {:include=>nil, :offset=>nil, :select=>nil, :joins=>nil, :limit=>nil, :group=>nil, :conditions=>"`prm_product_reports`.user_id = #{users(:quentin).id}", :readonly=>nil, :having=>nil}).and_return(mock_product_report)
        mock_product_report.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :product_report => {:these => 'params'}
      end

      it "assigns the requested product_report as @product_report" do
        ProductReport.stub!(:find).and_return(mock_product_report(:update_attributes => true))
        put :update, :id => "1"
        assigns[:product_report].should equal(mock_product_report)
      end

      it "redirects to the product_report" do
        ProductReport.stub!(:find).and_return(mock_product_report(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(product_report_products_path(mock_product_report))
      end
    end

    describe "with invalid params" do
      it "updates the requested product_report" do
        ProductReport.should_receive(:find).with("37", {:include=>nil, :offset=>nil, :select=>nil, :joins=>nil, :limit=>nil, :group=>nil, :conditions=>"`prm_product_reports`.user_id = #{users(:quentin).id}", :readonly=>nil, :having=>nil}).and_return(mock_product_report)
        mock_product_report.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :product_report => {:these => 'params'}
      end

      it "assigns the product_report as @product_report" do
        ProductReport.stub!(:find).and_return(mock_product_report(:update_attributes => false))
        put :update, :id => "1"
        assigns[:product_report].should equal(mock_product_report)
      end

      it "re-renders the 'edit' template" do
        ProductReport.stub!(:find).and_return(mock_product_report(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('new')
      end
    end

  end

  # describe "DELETE destroy" do
  #   it "destroys the requested product_report" do
  #     ProductReport.should_receive(:find).with("37").and_return(mock_product_report)
  #     mock_product_report.should_receive(:destroy)
  #     delete :destroy, :id => "37"
  #   end
  # 
  #   it "redirects to the product_reports list" do
  #     ProductReport.stub!(:find).and_return(mock_product_report(:destroy => true))
  #     delete :destroy, :id => "1"
  #     response.should redirect_to(product_reports_url)
  #   end
  # end

end
