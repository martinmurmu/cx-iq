class Category < ActiveRecord::Base
  set_table_name "category"
  has_many :product_categories, :dependent => :destroy
  has_many :products, :through => :product_categories
  has_many :product_reports, :as => :category
  has_many :sent_reports, :as => :category
  acts_as_tree :order => "name"
  
  def manufacturers
    q = "SELECT `manufacturer`.* FROM `manufacturer`  INNER JOIN `product` ON `manufacturer`.id = `product`.manufacturer INNER JOIN `product_category` ON `product`.id = `product_category`.product_id   WHERE ((`product_category`.category_id = #{id}))  GROUP BY `manufacturer` ORDER BY `manufacturer`.name"
    Manufacturer.find_by_sql q
  end     
  
  def is_root?
    parent_id.blank?
  end
  
  def to_s
    name
  end
  
  def most_recent_updated_product
    @most_recent_updated_product ||= products.find :first, :order => 'last_update DESC'
  end
  
  def number_of_product_reviews
    products.sum('all_reviews_count')
  end
  
  def children_with_products
    #children.find  :all, :joins => :product_categories, :select => "category.*, count(product_id) as products_count", :group => "category.id", :having => 'products_count > 35'
    children.find :all, :conditions => "products_count >= #{APP_CONFIG[:min_number_of_categories]}"
  end
   
  def children_with_children
    children.find  :all, :joins => :children, :select => "category.*, count(childrens_category.id) as child_count", :group => "category.id", :having => 'child_count > 0'
  end
  
  def children_with_children_and_products
    Category.find :all, :conditions => "attrib_left > #{attrib_left} AND attrib_right < #{attrib_right} AND products_count >= #{APP_CONFIG[:min_number_of_categories]}"
  end
  
  def children_having_children_and_products
    children.delete_if{|cat|
      !cat.has_children_with_children_and_products?
    }
  end
  
  def has_children_with_children_and_products?
    Category.count(:conditions => "attrib_left > #{attrib_left} AND attrib_right < #{attrib_right} AND products_count >= #{APP_CONFIG[:min_number_of_categories]}") > 0
  end
  
  def all_sub_children_with_products
    ch = all_sub_children
    ch.delete_if {|x| x.products_count < APP_CONFIG[:min_number_of_categories] }
  end
  
  def dom_id
    "category-#{id}"
  end
  
  def self.dom_id(id)
    "category-#{id}"
  end
  
  def update_node_attributes(attrib=1)
    update_attribute('attrib_left', attrib)
    attrib += 1
    children.each{|a|
      attrib = a.update_node_attributes(attrib)
    }
    update_attribute('attrib_right', attrib)
    attrib += 1
  end
  
  def self.find_by_manufacturer(man)
    find :all, :conditions => ["products_count >= #{APP_CONFIG[:min_number_of_categories]} AND id IN (SELECT DISTINCT product_category.category_id from product, product_category WHERE product.manufacturer = ? AND product.id = product_category.product_id)", man.id]
  end
  
  def self.find_by_product(product)
    find :all, :conditions => ["products_count >= #{APP_CONFIG[:min_number_of_categories]} AND id IN (SELECT DISTINCT product_category.category_id from product, product_category WHERE product.name = ? AND product.id = product_category.product_id)", product.name]
  end


end
