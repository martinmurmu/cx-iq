module ProductsHelper
  def name_with_ancestors(category)
    s = ""
    if category
      ancestors = category.ancestors.reverse
      if ancestors.length > 0
        ancestors.shift 
        ancestors.each{|cat|
          s += "#{link_to cat.name, cat} &gt; "
        }
      end
      s += category.name
    end
    s
  end
end
