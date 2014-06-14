require 'spec_helper'

describe User do

  fixtures :category, :prm_category_subscriptions

  before(:each) do
    @valid_attributes = {
      :email => "test@example.com",
      :password => "testtest"
    }
  end

  should_have_many :category_subscriptions
  should_have_many :categories, :through => :category_subscriptions

  should_have_many :sent_reports
  should_have_many :product_groups

  it 'should normally be valid' do
    Factory.build(:user).should be_valid
  end

  it "should know if it's subscribed to a certain category or not" do
    user = Factory(:user)
    subscribed_category = Factory(:category)
    category = Factory(:category)

    Factory(:category_subscription, :category => subscribed_category, :user => user)

    user.subscribed?(category).should be_false
    user.subscribed?(subscribed_category).should be_true
  end

  describe 'save' do

    it 'assignes default roles' do
      user = User.new(@valid_attributes)
      lambda {
        user.save
      }.should change(OemUserRole, :count).by(2)
      user.reload
      user.roles.should == [role(:one), role(:two)]
    end

    it 'creates legacy user' do
      user = User.new(@valid_attributes)
      lambda {
        user.save
      }.should change(OemUser, :count).by(1)
      oem_user = OemUser.find(:last)
      oem_user.id.should == user.reload.id
      oem_user.password.should == "testtest"
    end

  end

  describe 'allowed_to_generate_report?' do
    it 'allows one free report' do
      Factory(:user).allowed_to_generate_report?(nil).should be_true
    end

    it 'does not allow to generate report for users w/o subscriptions and used free report' do
      user = Factory(:user)
      category = Factory(:category)
      subscription = Factory(:category_subscription, :user => user, :category => category)

      user.should_receive(:reports_per_month_allowed).and_return(0)
      user.allowed_to_generate_report?(category).should be_true
      sr = Factory(:sent_report, :user => user, :complimentary => true, :usage => Factory(:product_report, :category => category, :user => user))
      user.reload
      user.allowed_to_generate_report?(category).should be_false
    end

    it 'allows report generation for a subscribed and paid category' do
      user = Factory(:user)
      category = Factory(:category)
      subscription = Factory(:category_subscription, :user => user, :category => category)

      user.should_receive(:reports_per_month_allowed).and_return(1)
      user.allowed_to_generate_report?(category).should be_true
      sr = Factory(:sent_report, :user => user, :complimentary => true, :usage => Factory(:product_report, :category => category, :user => user))
      user.reload
      user.allowed_to_generate_report?(category).should be_true
    end

    it 'allows unlimited report generations for a subscribed and paid category' do
      user = Factory(:user)
      category = Factory(:category)
      subscription = Factory(:category_subscription, :user => user, :category => category)

      user.should_receive(:reports_per_month_allowed).at_least(:once).and_return(1)
      user.allowed_to_generate_report?(category).should be_true
      sr = Factory(:sent_report, :user => user, :complimentary => true, :usage => Factory(:product_report, :category => category, :user => user), :category => category)
      sr = Factory(:sent_report, :user => user, :complimentary => false, :usage => Factory(:product_report, :category => category, :user => user), :category => category)
      sr = Factory(:sent_report, :user => user, :complimentary => false, :usage => Factory(:product_report, :category => category, :user => user), :category => category)
      user.reload
      user.allowed_to_generate_report?(category).should be_true
    end
    
    it 'allows unlimited report generations for more then one subscribed and paid category' do
      user = Factory(:user)
      category = Factory(:category)
      secondary_category = Factory(:category)
      subscription = Factory(:category_subscription, :user => user, :category => category)
      secondary_subscription = Factory(:category_subscription, :user => user, :category => secondary_category)

      user.should_receive(:reports_per_month_allowed).at_least(:once).and_return(2)

      user.allowed_to_generate_report?(category).should be_true
      sr = Factory(:sent_report, :user => user, :complimentary => true, :usage => Factory(:product_report, :category => category, :user => user), :category => category)
      sr = Factory(:sent_report, :user => user, :complimentary => false, :usage => Factory(:product_report, :category => category, :user => user), :category => category)
      sr = Factory(:sent_report, :user => user, :complimentary => false, :usage => Factory(:product_report, :category => category, :user => user), :category => category)
      user.reload
      user.allowed_to_generate_report?(category).should be_true

      user.allowed_to_generate_report?(secondary_category).should be_true
      sr = Factory(:sent_report, :user => user, :complimentary => true, :usage => Factory(:product_report, :category => secondary_category, :user => user), :category => category)
      sr = Factory(:sent_report, :user => user, :complimentary => false, :usage => Factory(:product_report, :category => secondary_category, :user => user), :category => category)
      sr = Factory(:sent_report, :user => user, :complimentary => false, :usage => Factory(:product_report, :category => secondary_category, :user => user), :category => category)
      user.reload
      user.allowed_to_generate_report?(secondary_category).should be_true
    end

    it 'user with 1 paid subscription should NOT be able to generate report to a secondary category if there is a report
        for the primary one generated within 1 month ago ' do
      user = Factory(:user)
      category = Factory(:category)
      secondary_category = Factory(:category)
      subscription = Factory(:category_subscription, :user => user, :category => category)
      secondary_subscription = Factory(:category_subscription, :user => user, :category => secondary_category)
      usage = Factory(:product_report, :category => category, :user => user)

      user.should_receive(:reports_per_month_allowed).at_least(:once).and_return(1)

      user.allowed_to_generate_report?(category).should be_true
      sr = Factory(:sent_report, :user => user, :complimentary => true, :usage => Factory(:product_report, :category => category, :user => user), :category => category)
      sr = Factory(:sent_report, :created_at => (Time.now.utc - 5.days).to_s(:db), :user => user, :complimentary => false, :usage => usage, :category => category)
      user.reload
      user.allowed_to_generate_report?(category).should be_true
      user.allowed_to_generate_report?(secondary_category).should be_false
    end

    it 'user with 1 paid subscription should be able to generate report to a secondary category if there is a report
        for the primary one generated more then 1 month ago ' do
      user = Factory(:user)
      category = Factory(:category)
      secondary_category = Factory(:category)
      subscription = Factory(:category_subscription, :user => user, :category => category)
      secondary_subscription = Factory(:category_subscription, :user => user, :category => secondary_category)
      usage = Factory(:product_report, :category => category, :user => user)

      user.should_receive(:reports_per_month_allowed).and_return(1)

      user.allowed_to_generate_report?(category).should be_true
      sr = Factory(:sent_report, :user => user, :complimentary => true, :usage => Factory(:product_report, :category => category, :user => user))
      sr = Factory(:sent_report, :created_at => (Time.now.utc - 1.month - 5.days).to_s(:db), :user => user, :complimentary => false, :usage => usage)
      user.reload
#      user.allowed_to_generate_report?(category.id).should be_true
      user.allowed_to_generate_report?(secondary_category).should be_true
    end

  end

  describe 'my products' do
    it 'has many products through product_groups' do
      user = Factory(:user)
      group = Factory(:product_group, :one_product_group => true, :user => user)
      product = Factory(:product)
      groupping = Factory(:product_grouping, :product => product, :product_group => group)
      user.my_products.should == [product]
    end
  end

end
