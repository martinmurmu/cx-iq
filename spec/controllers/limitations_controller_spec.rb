#require 'spec_helper'
#
#describe LimitationsController do
#
#  def mock_limitation(stubs={})
#    @mock_limitation ||= mock_model(Limitation, stubs)
#  end
#
#  describe "GET index" do
#    it "assigns all limitations as @limitations" do
#      Limitation.stub(:find).with(:all).and_return([mock_limitation])
#      get :index
#      assigns[:limitations].should == [mock_limitation]
#    end
#  end
#
#  describe "GET show" do
#    it "assigns the requested limitation as @limitation" do
#      Limitation.stub(:find).with("37").and_return(mock_limitation)
#      get :show, :id => "37"
#      assigns[:limitation].should equal(mock_limitation)
#    end
#  end
#
#  describe "GET new" do
#    it "assigns a new limitation as @limitation" do
#      Limitation.stub(:new).and_return(mock_limitation)
#      get :new
#      assigns[:limitation].should equal(mock_limitation)
#    end
#  end
#
#  describe "GET edit" do
#    it "assigns the requested limitation as @limitation" do
#      Limitation.stub(:find).with("37").and_return(mock_limitation)
#      get :edit, :id => "37"
#      assigns[:limitation].should equal(mock_limitation)
#    end
#  end
#
#  describe "POST create" do
#
#    describe "with valid params" do
#      it "assigns a newly created limitation as @limitation" do
#        Limitation.stub(:new).with({'these' => 'params'}).and_return(mock_limitation(:save => true))
#        post :create, :limitation => {:these => 'params'}
#        assigns[:limitation].should equal(mock_limitation)
#      end
#
#      it "redirects to the created limitation" do
#        Limitation.stub(:new).and_return(mock_limitation(:save => true))
#        post :create, :limitation => {}
#        response.should redirect_to(limitation_url(mock_limitation))
#      end
#    end
#
#    describe "with invalid params" do
#      it "assigns a newly created but unsaved limitation as @limitation" do
#        Limitation.stub(:new).with({'these' => 'params'}).and_return(mock_limitation(:save => false))
#        post :create, :limitation => {:these => 'params'}
#        assigns[:limitation].should equal(mock_limitation)
#      end
#
#      it "re-renders the 'new' template" do
#        Limitation.stub(:new).and_return(mock_limitation(:save => false))
#        post :create, :limitation => {}
#        response.should render_template('new')
#      end
#    end
#
#  end
#
#  describe "PUT update" do
#
#    describe "with valid params" do
#      it "updates the requested limitation" do
#        Limitation.should_receive(:find).with("37").and_return(mock_limitation)
#        mock_limitation.should_receive(:update_attributes).with({'these' => 'params'})
#        put :update, :id => "37", :limitation => {:these => 'params'}
#      end
#
#      it "assigns the requested limitation as @limitation" do
#        Limitation.stub(:find).and_return(mock_limitation(:update_attributes => true))
#        put :update, :id => "1"
#        assigns[:limitation].should equal(mock_limitation)
#      end
#
#      it "redirects to the limitation" do
#        Limitation.stub(:find).and_return(mock_limitation(:update_attributes => true))
#        put :update, :id => "1"
#        response.should redirect_to(limitation_url(mock_limitation))
#      end
#    end
#
#    describe "with invalid params" do
#      it "updates the requested limitation" do
#        Limitation.should_receive(:find).with("37").and_return(mock_limitation)
#        mock_limitation.should_receive(:update_attributes).with({'these' => 'params'})
#        put :update, :id => "37", :limitation => {:these => 'params'}
#      end
#
#      it "assigns the limitation as @limitation" do
#        Limitation.stub(:find).and_return(mock_limitation(:update_attributes => false))
#        put :update, :id => "1"
#        assigns[:limitation].should equal(mock_limitation)
#      end
#
#      it "re-renders the 'edit' template" do
#        Limitation.stub(:find).and_return(mock_limitation(:update_attributes => false))
#        put :update, :id => "1"
#        response.should render_template('edit')
#      end
#    end
#
#  end
#
#  describe "DELETE destroy" do
#    it "destroys the requested limitation" do
#      Limitation.should_receive(:find).with("37").and_return(mock_limitation)
#      mock_limitation.should_receive(:destroy)
#      delete :destroy, :id => "37"
#    end
#
#    it "redirects to the limitations list" do
#      Limitation.stub(:find).and_return(mock_limitation(:destroy => true))
#      delete :destroy, :id => "1"
#      response.should redirect_to(limitations_url)
#    end
#  end
#
#end
