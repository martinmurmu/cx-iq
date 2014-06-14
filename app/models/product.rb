#require "acts_as_ferret"

class Product < ActiveRecord::Base
  set_table_name "product"
  has_many :product_category
  has_many :categories, :through => :product_category
  has_many :reviews
  
  belongs_to :manufacturer, :class_name => 'Manufacturer',:foreign_key => 'manufacturer'

  has_one :recent_review, :class_name => "Review", :order => "recieve_date DESC"

  attr_accessor :custom_csv_data

#  acts_as_ferret :fields => [ :name ]

  comma do

    name
    manufacturer_name_from_preloaded_list 'Manufacturer'
    csi_score
    functionality_score
    reliability_score
    support_score
    number_of_reviews

  end

  comma :nps do
    name
    manufacturer_name_from_preloaded_list 'Manufacturer'
    nps_score
    last_update
    number_of_reviews
  end

  def number_of_reviews
    @number_of_reviews ||= reviews_count
  end

  def to_s
    name
  end


  #this is emulation of ferret using native mysql 
  #nk, 2014
  def self.find_with_ferret term, opts = {}
    #using native mysql search in dev env
    return [] if term.blank?
    term.gsub!('"',"")
    term.gsub!("*","")
    words = term.to_s.downcase.split(" ")
    condition_template = ""
    condition_values = []
    order = ""
    words.each do |word|
      condition_template += " OR " if !condition_template.blank?
      condition_template += "(LOWER(name) like ?)"
      condition_values << "%#{word}%"
      order += " + " if !order.blank?
      order += "(LOWER(name) like ?)"
    end
    order = ActiveRecord::Base.send(:sanitize_sql_array,[order]+condition_values)
    opts = opts.merge( {:order=>"(#{order}) desc",:conditions=>[condition_template]+condition_values})
    paginate = {}
    if opts.has_key? :page
      paginate[:page] = opts[:page] 
      opts.delete :page
    end

    if opts.has_key? :per_page
      paginate[:per_page] = opts[:per_page]
      opts.delete :per_page
    end

    ret = self.find(:all, opts)
    if !paginate.blank?
      ret.paginate(paginate)
    else
      ret
    end
  end

  def manufacturer_name_from_preloaded_list
    custom_csv_data[:manufacturers][attributes['manufacturer']]
  end

  def reviews_count
    all_reviews_count
  end

  def reliability_reviews(options = {})
    reviews.all({:conditions => "reliability_score != 1"}.merge(options))
  end

  def functionality_reviews(options = {})
    reviews.all({:conditions => "functionality_score != 1"}.merge(options))
  end

  def support_reviews(options = {})
    reviews.all({:conditions => "support_score != 1"}.merge(options))
  end

  def self.product_category_search(name, type, user, page = 1)
    categories = []
    #{"manufacturer"=>"LG", "product"=>"Portable Stereo Speakers", "categories"=>[{"fullPath"=>"Portable Audio & Video > MP3 Players & Accessories > MP3 Player Accessories > Speaker Systems", "id"=>330, "subscribed"=>false}]}
    products = Product.find_with_ferret("#{name}*", :page => page.blank? ? 1 : page)
    products.each{|p|
      #categories << {'product' => p.name, :categories => [{"fullPath"=>"Portab"}]}
      categories <<  {"manufacturer"=>p.manufacturer.try(:name), "product"=>p.name, "categories"=>[{"fullPath"=>p.categories.first.name, "id"=>p.categories.first.id, "subscribed"=>user.subscribed?(p.categories.first)}]}
    }
    p categories
    categories.paginate(:page => products.current_page, :per_page => products.per_page, :total_entries => products.total_entries)
  end

  # returns products added to My Lists of users
  def self.active_products
    Product.find_by_sql("SELECT id,  all_reviews_count FROM product WHERE id IN (SELECT DISTINCT(product_id) FROM  product_groupings) LIMIT 5000")
  end

end
