require 'spec_helper'

describe WomRequestsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/wom_requests" }.should route_to(:controller => "wom_requests", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/wom_requests/new" }.should route_to(:controller => "wom_requests", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/wom_requests/1" }.should route_to(:controller => "wom_requests", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/wom_requests/1/edit" }.should route_to(:controller => "wom_requests", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/wom_requests" }.should route_to(:controller => "wom_requests", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/wom_requests/1" }.should route_to(:controller => "wom_requests", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/wom_requests/1" }.should route_to(:controller => "wom_requests", :action => "destroy", :id => "1") 
    end
  end
end
