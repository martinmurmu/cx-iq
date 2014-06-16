Factory.sequence :text_id do |n|
  "#{n}37e34d90b0eb04815bd19b3e24"
end

Factory.sequence :email do |n|
  "person#{n}_#{Time.now.to_i}@example.com"
end


Factory.define :user do |u|
  u.email { Factory.next :email }
  u.password   'testtest'
end

Factory.define :category do |c|
  c.name    'test_category'
end

Factory.define :category_subscription do |cs|
  cs.association :user
  cs.association :category
end

Factory.define :manufacturer do |m|
  m.id { Factory.next :text_id }
  m.sequence(:name){|n| "manufacturer_#{n}"}
end

Factory.define :product_report do |r|
  r.association :product_category, :factory => :category
  r.sorting_field 1
  r.sorting_order 2
  r.number_of_reviews 1
  r.csi_range 1 
  r.pfs_range 1
  r.prs_range 1
  r.pss_range 1
  r.association :user
  r.per_page 20
  r.filtered false
end

Factory.define :product_category do |pc|
  pc.association :category
  pc.association :product
end

Factory.define :product do |p|
  p.association :manufacturer
  p.last_update Time.now.to_s(:db)
end

Factory.define :sent_report do |sr|
  sr.association :user
  sr.association :usage, :factory => :product_report
  sr.category {|a| a.usage.product_category }
  sr.output_format 'pdf'
end

Factory.define :product_group do |pg|
  pg.association :user
  pg.name 'My list'
  pg.one_product_group false
end

Factory.define :product_grouping do |pg|
  pg.association :product
  pg.association :product_group
end

Factory.define :report_product_filter do |pg|
  pg.association :product_report
  pg.association :product
end

