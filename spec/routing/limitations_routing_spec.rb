require 'spec_helper'

describe LimitationsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/limitations" }.should route_to(:controller => "limitations", :action => "index")
    end

#    it "recognizes and generates #new" do
#      { :get => "/limitations/new" }.should route_to(:controller => "limitations", :action => "new")
#    end

    it "recognizes and generates #show" do
      { :get => "/limitations/1" }.should route_to(:controller => "limitations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/limitations/1/edit" }.should route_to(:controller => "limitations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/limitations" }.should route_to(:controller => "limitations", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/limitations/1" }.should route_to(:controller => "limitations", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/limitations/1" }.should route_to(:controller => "limitations", :action => "destroy", :id => "1") 
    end
  end
end
