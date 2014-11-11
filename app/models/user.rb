class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :last_name, :first_name, :terms_of_service, :company

  validates_acceptance_of :terms_of_service, :accept => "1"

  has_many :oem_user_roles, :foreign_key => :oem_user_id 
  has_many :roles, :through => :oem_user_roles

  has_many :category_subscriptions
  has_many :categories, :through => :category_subscriptions
  has_many :product_reports
  has_many :nps_reports

  has_many :sent_reports
  has_many :product_groups,  ->{ where one_product_group: false}

  has_many :my_one_product_groups, ->{ where one_product_group: true }, class_name: 'ProductGroup'

  has_one :limitation

  after_create :add_default_roles
  after_create :add_legacy_user

  #default_value_for :send_review_updates, true
  
  def full_name
    [first_name, last_name].join ' '
  end

  def add_default_roles
    roles << Role.find_by_name('v2p.user')
    roles << Role.find_by_name('prmir.user')
  end

  def add_legacy_user
    oem_user = OemUser.new(
      :email => email,
      :username => email,
      :last_name => last_name,
      :first_name => first_name,
      :password => password
    )
    oem_user.id = id
    oem_user.save
  end

  #TODO should be removed after the DB merge  
  def categories
    @categories ||= Category.find(self.category_subscriptions.map{|e| e.category_id})
  end

  #TODO use associations after the DB merge
  def subscribed? category
    CategorySubscription.exists?(:user_id => id, :category_id => category.id)
  end

  def subscribe category
    unless subscribed? category
      category_subscriptions.build(:category_id => category.id).save
      @categories = nil
    end
  end

  def unsubscribe category
    CategorySubscription.delete_all(["category_id = ? AND user_id = ?", category.id, id])
    @categories = nil
  end

  def full_name
    [first_name, last_name].join ' '
  end

  def reviewer_name
    reviewer = full_name
    if reviewer == " "
      reviewer = email
    end
    reviewer
  end

  def categories_subscriptions_allowed
    9999999
    # spreedly_subscriber = Spreedly::Subscriber.find id
    # if spreedly_subscriber.blank?
    #   create_spreedly_subscriber
    #   subscribe_to_trial
    #   spreedly_subscriber = Spreedly::Subscriber.find id
    # end
    # spreedly_subscriber.active? ? spreedly_subscriber.feature_level.to_i : 0
  end

  def reports_per_month_allowed

    limitation.nil? ? 0 : limitation.prm_reports
#    spreedly_subscriber = get_spreedly_subscriber
#    spreedly_subscriber.active? ? spreedly_subscriber.feature_level.to_i : 0
  end

#  def get_spreedly_subscriber
#    @spreedly_subscriber ||= Spreedly::Subscriber.find id
#    if @spreedly_subscriber.blank?
#      create_spreedly_subscriber
#      #subscribe_to_trial
#      @spreedly_subscriber = Spreedly::Subscriber.find id
#    end
#    @spreedly_subscriber
#  end

  def guest?
    false
  end

  def number_of_reports_sent_within_month(category_id=nil)
    SentReport.count_by_sql "SELECT COUNT(*) FROM sent_reports WHERE user_id = #{id} AND complimentary = false AND created_at > '#{(Time.now.utc - 1.month).to_s(:db)}'"
  end

  def allowed_to_generate_report?(category)
    return true if sent_reports.size == 0 #allow 1 free report

    if reports_per_month_allowed > 0
      cats = distinct_categories_with_reports_within_last_month
      groups = distinct_product_groups_with_reports_within_last_month
      return true if (cats.empty? && groups.empty?) || (cats.size + groups.size) < reports_per_month_allowed || (category.is_a?(Category) && cats.any?{|c| c.id == category.id}) || (category.is_a?(ProductGroup) && groups.any?{|c| c.id == category.id})
    end
    false
  end

  def allowed_to_create_new_product_group?
    limitation.nil? ? false : limitation.my_lists > product_groups.size + my_one_product_groups.size
  end

  def distinct_categories_with_reports_within_last_month
    @distinct_categories_with_reports_within_last_month ||= Category.find_by_sql("
      SELECT DISTINCT category.*
      FROM category, sent_reports
      WHERE category.id = sent_reports.category_id 
      AND sent_reports.usage_type = 'ProductReport'
      AND sent_reports.category_type = 'Category'
      AND sent_reports.user_id = #{id} AND sent_reports.complimentary = false AND sent_reports.created_at > '#{(Time.now.utc - 1.month).to_s(:db)}'
    ")
  end

  def distinct_product_groups_with_reports_within_last_month
    @distinct_product_groups_with_reports_within_last_month ||= ProductGroup.find_by_sql("
      SELECT DISTINCT product_groups.*
      FROM product_groups, sent_reports
      WHERE product_groups.id = sent_reports.category_id
      AND sent_reports.usage_type = 'ProductReport'
      AND sent_reports.category_type = 'ProductGroup'
      AND sent_reports.user_id = #{id} AND sent_reports.complimentary = false AND sent_reports.created_at > '#{(Time.now.utc - 1.month).to_s(:db)}'
    ")
  end

  def allowed_to_add_another_product_to_group?(product_group, number_of_new_products = 1)
    if product_group.nil? || limitation.nil?
      return false
    else
      if product_group.new_record?
        return limitation.products_per_list >= number_of_new_products
      else
        return limitation.products_per_list >= product_group.products.size + number_of_new_products
      end
    end
  end

  def paying_customer?
    !limitation.nil?
  end

  def my_products
    my_one_product_groups.map{|x| x.products[0]}
  end

  def admin?
    roles.include?(Role.find_by_name('v2p.admin'))
  end

  def to_s
    "#{full_name}, #{email}, id: #{id}"
  end
  
  #creates sample user groups
  def generate_sample_products
    self.product_groups.destroy_all
    group = self.product_groups.create :name=>"Market Segment 1 - smart phones"

    ["apple iphone 5%","samsung galaxy s3%","nokia lumia 920%"].each { |product_name|
      group.products << (Product.find :first, :conditions=>"name like '#{product_name}'")
    }
    group.save
    
    group = self.product_groups.create :name=>"Market Segment 2 - printers"
    ["Lexmark Prospect Pro205","Epson Workforce 645 Printer","Canon Pixma MX420 Printer"].each { |product_name|
      group.products << (Product.find :first, :conditions=>"name like '#{product_name}'")
    }
    group.save
    
    
    self.my_one_product_groups.destroy_all
    product = (Product.find :first, :conditions=>"name like 'Toyota 2011 Camry'")
    group = self.my_one_product_groups.create(:name => product.id)
    group.products << product
    group.save

    product = (Product.find :first, :conditions=>"name like 'Golfshot Mobile App'")
    group = self.my_one_product_groups.create(:name => product.id)
    group.products << product
    group.save
  end

  private

#  def create_spreedly_subscriber
#    Spreedly::Subscriber.create! id, email, full_name
#  end

  # def subscribe_to_trial
  #   spreedly_subscriber = Spreedly::Subscriber.find id
  #   spreedly_subscriber.activate_free_trial SpreedlySubscription::TRIAL_PLAN
  # end
end
