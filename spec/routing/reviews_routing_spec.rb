require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReviewsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "reviews", :action => "index").should == "/reviews"
    end

    it "maps #new" do
      route_for(:controller => "reviews", :action => "new").should == "/reviews/new"
    end

    it "maps #show" do
      route_for(:controller => "reviews", :action => "show", :id => "1").should == "/reviews/1"
    end

    it "maps #edit" do
      route_for(:controller => "reviews", :action => "edit", :id => "1").should == "/reviews/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "reviews", :action => "create").should == {:path => "/reviews", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "reviews", :action => "update", :id => "1").should == {:path =>"/reviews/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "reviews", :action => "destroy", :id => "1").should == {:path =>"/reviews/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/reviews").should == {:controller => "reviews", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/reviews/new").should == {:controller => "reviews", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/reviews").should == {:controller => "reviews", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/reviews/1").should == {:controller => "reviews", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/reviews/1/edit").should == {:controller => "reviews", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/reviews/1").should == {:controller => "reviews", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/reviews/1").should == {:controller => "reviews", :action => "destroy", :id => "1"}
    end
  end
end
