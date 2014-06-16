require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProductReportsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "product_reports", :action => "index").should == "/product_reports"
    end

    it "maps #new" do
      route_for(:controller => "product_reports", :action => "new").should == "/product_reports/new"
    end

    it "maps #show" do
      route_for(:controller => "product_reports", :action => "show", :id => "1").should == "/product_reports/1"
    end

    it "maps #edit" do
      route_for(:controller => "product_reports", :action => "edit", :id => "1").should == "/product_reports/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "product_reports", :action => "create").should == {:path => "/product_reports", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "product_reports", :action => "update", :id => "1").should == {:path =>"/product_reports/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "product_reports", :action => "destroy", :id => "1").should == {:path =>"/product_reports/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/product_reports").should == {:controller => "product_reports", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/product_reports/new").should == {:controller => "product_reports", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/product_reports").should == {:controller => "product_reports", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/product_reports/1").should == {:controller => "product_reports", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/product_reports/1/edit").should == {:controller => "product_reports", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/product_reports/1").should == {:controller => "product_reports", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/product_reports/1").should == {:controller => "product_reports", :action => "destroy", :id => "1"}
    end
  end
end
