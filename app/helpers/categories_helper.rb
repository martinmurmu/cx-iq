module CategoriesHelper
  
  def ancestors_navbar(category, top_cat_name = 'Top Categories')
    if category.is_root?
      return "<li><a href=\"#{categories_path}\" class=\"crumb_highlight\"><span>#{top_cat_name}</span></a></li>"
    else
      s = "<li><a href=\"#{categories_path}\" class=\"crumb\"><span>Top Categories</span></a></li>"
      ancestors = category.ancestors.reverse
      ancestors.shift
      ancestors.each{|cat|
        s += "<li><a href=\"#{category_path(cat)}\" class=\"crumb\"><span>...</span></a></li>"
      }
      s += "<li><a href=\"#{category_path(category)}\" class=\"crumb_highlight\"><span>#{category.name}</span></a></li>"
      return s
    end
  end
  
  def name_with_ancestors(category)
    s = ""
    ancestors = category.ancestors.reverse
    ancestors.shift
    ancestors.each{|cat|
      s += "#{link_to cat.name, cat} &gt; "
    }
    s += category.name
  end
  
end
