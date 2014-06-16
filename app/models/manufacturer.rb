class Manufacturer < ActiveRecord::Base
  set_table_name "manufacturer"
  has_many :products
  default_scope :conditions => 'hidden = 0'
  
  def to_s
    name
  end
  
  def self.names_by_ids(ids)
    names={}
    ids.compact!
    Manufacturer.find(ids).each{|m|
      names[m.id] = m.name  
    } unless ids.blank?  
    names
  end
  
end
