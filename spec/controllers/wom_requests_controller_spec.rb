require 'spec_helper'

describe WomRequestsController do

  def mock_wom_request(stubs={})
    @mock_wom_request ||= mock_model(WomRequest, stubs)
  end

#  describe "GET index" do
#    it "assigns all wom_requests as @wom_requests" do
#      WomRequest.stub(:find).with(:all).and_return([mock_wom_request])
#      get :index
#      assigns[:wom_requests].should == [mock_wom_request]
#    end
#  end
#
#  describe "GET show" do
#    it "assigns the requested wom_request as @wom_request" do
#      WomRequest.stub(:find).with("37").and_return(mock_wom_request)
#      get :show, :id => "37"
#      assigns[:wom_request].should equal(mock_wom_request)
#    end
#  end

  describe "GET new" do
    it "assigns a new wom_request as @wom_request" do
      WomRequest.stub(:new).and_return(mock_wom_request)
      get :new
      assigns[:wom_request].should equal(mock_wom_request)
    end
  end

#  describe "GET edit" do
#    it "assigns the requested wom_request as @wom_request" do
#      WomRequest.stub(:find).with("37").and_return(mock_wom_request)
#      get :edit, :id => "37"
#      assigns[:wom_request].should equal(mock_wom_request)
#    end
#  end

  describe "POST create" do

    describe "with valid params" do
#      it "assigns a newly created wom_request as @wom_request" do
#        WomRequest.stub(:new).with({'these' => 'params'}).and_return(mock_wom_request(:save => true))
#        post :create, :wom_request => {:these => 'params'}
#        assigns[:wom_request].should equal(mock_wom_request)
#      end

#      it "redirects to the created wom_request" do
#        WomRequest.stub(:new).and_return(mock_wom_request(:save => true))
#        post :create, :wom_request => {}
#        response.should redirect_to(wom_request_url(mock_wom_request))
#      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved wom_request as @wom_request" do
        WomRequest.stub(:new).with({'these' => 'params'}).and_return(mock_wom_request(:save => false))
        post :create, :wom_request => {:these => 'params'}
        assigns[:wom_request].should equal(mock_wom_request)
      end

      it "re-renders the 'new' template" do
        WomRequest.stub(:new).and_return(mock_wom_request(:save => false))
        post :create, :wom_request => {}
        response.should render_template('new')
      end
    end

  end

#  describe "PUT update" do
#
#    describe "with valid params" do
#      it "updates the requested wom_request" do
#        WomRequest.should_receive(:find).with("37").and_return(mock_wom_request)
#        mock_wom_request.should_receive(:update_attributes).with({'these' => 'params'})
#        put :update, :id => "37", :wom_request => {:these => 'params'}
#      end
#
#      it "assigns the requested wom_request as @wom_request" do
#        WomRequest.stub(:find).and_return(mock_wom_request(:update_attributes => true))
#        put :update, :id => "1"
#        assigns[:wom_request].should equal(mock_wom_request)
#      end
#
#      it "redirects to the wom_request" do
#        WomRequest.stub(:find).and_return(mock_wom_request(:update_attributes => true))
#        put :update, :id => "1"
#        response.should redirect_to(wom_request_url(mock_wom_request))
#      end
#    end
#
#    describe "with invalid params" do
#      it "updates the requested wom_request" do
#        WomRequest.should_receive(:find).with("37").and_return(mock_wom_request)
#        mock_wom_request.should_receive(:update_attributes).with({'these' => 'params'})
#        put :update, :id => "37", :wom_request => {:these => 'params'}
#      end
#
#      it "assigns the wom_request as @wom_request" do
#        WomRequest.stub(:find).and_return(mock_wom_request(:update_attributes => false))
#        put :update, :id => "1"
#        assigns[:wom_request].should equal(mock_wom_request)
#      end
#
#      it "re-renders the 'edit' template" do
#        WomRequest.stub(:find).and_return(mock_wom_request(:update_attributes => false))
#        put :update, :id => "1"
#        response.should render_template('edit')
#      end
#    end
#
#  end

#  describe "DELETE destroy" do
#    it "destroys the requested wom_request" do
#      WomRequest.should_receive(:find).with("37").and_return(mock_wom_request)
#      mock_wom_request.should_receive(:destroy)
#      delete :destroy, :id => "37"
#    end
#
#    it "redirects to the wom_requests list" do
#      WomRequest.stub(:find).and_return(mock_wom_request(:destroy => true))
#      delete :destroy, :id => "1"
#      response.should redirect_to(wom_requests_url)
#    end
#  end

end
