require 'spec_helper'

describe UserMessagesController do

  def mock_user_messages(stubs={})
    @mock_user_messages ||= mock_model(UserMessages, stubs)
  end

#  describe "GET index" do
#    it "assigns all user_messages as @user_messages" do
#      UserMessages.stub(:find).with(:all).and_return([mock_user_messages])
#      get :index
#      assigns[:user_messages].should == [mock_user_messages]
#    end
#  end

#  describe "GET show" do
#    it "assigns the requested user_messages as @user_messages" do
#      UserMessages.stub(:find).with("37").and_return(mock_user_messages)
#      get :show, :id => "37"
#      assigns[:user_messages].should equal(mock_user_messages)
#    end
#  end

  describe "GET new" do
    it "assigns a new user_messages as @user_messages" do
      UserMessages.stub(:new).and_return(mock_user_messages)
      get :new
      assigns[:user_messages].should equal(mock_user_messages)
    end
  end

#  describe "GET edit" do
#    it "assigns the requested user_messages as @user_messages" do
#      UserMessages.stub(:find).with("37").and_return(mock_user_messages)
#      get :edit, :id => "37"
#      assigns[:user_messages].should equal(mock_user_messages)
#    end
#  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created user_messages as @user_messages" do
        UserMessages.stub(:new).with({'these' => 'params'}).and_return(mock_user_messages(:save => true, :name => "asd", :email => "asd@example.com", :company=>'test', :message => 'test msg'))
        post :create, :user_messages => {:these => 'params'}
        assigns[:user_messages].should equal(mock_user_messages)
      end

#      it "redirects to the created user_messages" do
#        UserMessages.stub(:new).and_return(mock_user_messages(:save => true))
#        post :create, :user_messages => {}
#        response.should redirect_to(user_message_url(mock_user_messages))
#      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user_messages as @user_messages" do
        UserMessages.stub(:new).with({'these' => 'params'}).and_return(mock_user_messages(:save => false))
        post :create, :user_messages => {:these => 'params'}
        assigns[:user_messages].should equal(mock_user_messages)
      end

      it "re-renders the 'new' template" do
        UserMessages.stub(:new).and_return(mock_user_messages(:save => false))
        post :create, :user_messages => {}
        response.should render_template('new')
      end
    end

  end

#  describe "PUT update" do
#
#    describe "with valid params" do
#      it "updates the requested user_messages" do
#        UserMessages.should_receive(:find).with("37").and_return(mock_user_messages)
#        mock_user_messages.should_receive(:update_attributes).with({'these' => 'params'})
#        put :update, :id => "37", :user_messages => {:these => 'params'}
#      end
#
#      it "assigns the requested user_messages as @user_messages" do
#        UserMessages.stub(:find).and_return(mock_user_messages(:update_attributes => true))
#        put :update, :id => "1"
#        assigns[:user_messages].should equal(mock_user_messages)
#      end
#
#      it "redirects to the user_messages" do
#        UserMessages.stub(:find).and_return(mock_user_messages(:update_attributes => true))
#        put :update, :id => "1"
#        response.should redirect_to(user_message_url(mock_user_messages))
#      end
#    end
#
#    describe "with invalid params" do
#      it "updates the requested user_messages" do
#        UserMessages.should_receive(:find).with("37").and_return(mock_user_messages)
#        mock_user_messages.should_receive(:update_attributes).with({'these' => 'params'})
#        put :update, :id => "37", :user_messages => {:these => 'params'}
#      end
#
#      it "assigns the user_messages as @user_messages" do
#        UserMessages.stub(:find).and_return(mock_user_messages(:update_attributes => false))
#        put :update, :id => "1"
#        assigns[:user_messages].should equal(mock_user_messages)
#      end
#
#      it "re-renders the 'edit' template" do
#        UserMessages.stub(:find).and_return(mock_user_messages(:update_attributes => false))
#        put :update, :id => "1"
#        response.should render_template('edit')
#      end
#    end
#
#  end

#  describe "DELETE destroy" do
#    it "destroys the requested user_messages" do
#      UserMessages.should_receive(:find).with("37").and_return(mock_user_messages)
#      mock_user_messages.should_receive(:destroy)
#      delete :destroy, :id => "37"
#    end
#
#    it "redirects to the user_messages list" do
#      UserMessages.stub(:find).and_return(mock_user_messages(:destroy => true))
#      delete :destroy, :id => "1"
#      response.should redirect_to(user_messages_url)
#    end
#  end

end
