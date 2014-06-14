namespace :db do
  desc "Updates categories left and right attributes"
  task :update_category_attribs => :environment do |rake_task|
      update_category_attribs
  end


  desc "recalculates category.products_count"
  task :recalculate_cached_counters => :environment do |rake_task|
    recalculate_cached_counters
  end
  
  def update_category_attribs
    Category.root.update_node_attributes(1)
  end

  def recalculate_cached_counters
    Category.find_in_batches do |group|
      group.each{|c|
        c.update_attributes(:products_count => c.product_categories.count)
      }
    end
  end
  
end