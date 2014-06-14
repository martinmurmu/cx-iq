class ProductGroup < ActiveRecord::Base
  belongs_to :user
  has_many :product_groupings, :dependent => :destroy
  has_many :products, :through => :product_groupings
  has_many :product_reports, :as => :category
#  has_many :manufacturers, :through => :product_groupings

  default_value_for :one_product_group, false

  validates_uniqueness_of :name, :scope => :user_id
  validates_length_of :name, :in => 1..50, :allow_nil => false

  def manufacturers
    q = "SELECT `manufacturer`.* FROM `manufacturer`  INNER JOIN `product` ON `manufacturer`.id = `product`.manufacturer INNER JOIN `product_groupings` ON `product`.id = `product_groupings`.product_id   WHERE ((`product_groupings`.product_group_id = #{id}))  GROUP BY `manufacturer` ORDER BY `manufacturer`.name"
    Manufacturer.find_by_sql q
  end

  def self.create_from_filtered_product_report(report, user, name)
    group = user.product_groups.build(:name => name)
    if group.save
      report.filtered_products.each{|product|
        group.products << product
      }
    end
    group
  end

  def to_s
    name
  end
  
  def number_of_product_reviews
    products.sum('all_reviews_count')
  end

  def keywords_list
    keywords.blank? ? [] : keywords.try(:split,("\n")).map{|x| x.split(' => ')}.map{|x| x.first}
  end
  
end
