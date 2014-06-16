require 'spec_helper'

describe UserMessagesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/user_messages" }.should route_to(:controller => "user_messages", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/user_messages/new" }.should route_to(:controller => "user_messages", :action => "new")
    end

#    it "recognizes and generates #show" do
#      { :get => "/user_messages/1" }.should route_to(:controller => "user_messages", :action => "show", :id => "1")
#    end

#    it "recognizes and generates #edit" do
#      { :get => "/user_messages/1/edit" }.should route_to(:controller => "user_messages", :action => "edit", :id => "1")
#    end

    it "recognizes and generates #create" do
      { :post => "/user_messages" }.should route_to(:controller => "user_messages", :action => "create") 
    end

#    it "recognizes and generates #update" do
#      { :put => "/user_messages/1" }.should route_to(:controller => "user_messages", :action => "update", :id => "1")
#    end

#    it "recognizes and generates #destroy" do
#      { :delete => "/user_messages/1" }.should route_to(:controller => "user_messages", :action => "destroy", :id => "1")
#    end
  end
end
