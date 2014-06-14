module ProductReportsHelper
  DISPLAY_OPTIONS=[{:value=>20, :name=>"Display 20"},{:value=>50, :name=>"Display 50"},{:value=>100, :name=>"Display 100"}]
  
  def per_page_select(default=20, html_class="rowdd", html_style="")
    
    options = ""
    DISPLAY_OPTIONS.each{|opt|
      options += "<option value=\"#{opt[:value]}\""
      options += "SELECTED" if default == opt[:value]
      options += ">#{opt[:name]}</option>"
    }
    select_tag "per_page", options, :onchange => "#{remote_function(:url  => {:controller => 'product_reports', :action => "refresh", :id => @report.id},
                                                           :with => "'per_page='+value", :loading => "Element.show('loading_bar')", :complete => "Element.hide('loading_bar')")}", :class=>html_class, :style =>html_style
  end
  
  def product_category_select(categories, product_groups, selected=nil)
#    options="<option value=0>All</option>" 
    options = ""

    unless categories.nil? || categories.empty?
      options += "<option value=''>-- Categories --</option>"
      categories.each{|cat|
        options += "<option value=#{cat.id}_category#{" SELECTED" if selected=="#{cat.id}_category" || (!selected.blank? && selected.id==cat.id && selected.is_a?(Category))}>#{cat.name}</option>"
      }
    end
    unless product_groups.nil? || product_groups.empty?
      options += "<option value=''>-- My Lists --</option>"
      product_groups.each{|cat|
        options += "<option value=#{cat.id}_group#{" SELECTED" if selected=="#{cat.id}_group" || (!selected.blank? && selected.id==cat.id && selected.is_a?(ProductGroup))}>#{cat.name}</option>"
      }
    end


    select_tag "product_report[product_category_id]", options, :style=>"margin: 0 0 0 23px;", :onchange => "#{remote_function(:url  => {:action => "update_manufacturers"}, :with => "'category_id='+value", :loading => "Element.show('loading_bar')", :complete => "Element.hide('loading_bar')" )}"
  end
  
  def manufacturer_select(manufacturers, selected=[])
    if manufacturers.empty?
      options="<option value=''>Select Category</option>"
    else
      options="<option value='all' #{" SELECTED" if selected.blank?}>All Manufacturers</option>"

      manufacturers.each{|man|
        options += "<option value=#{man.id}#{" SELECTED" if selected.include?(man.id)}>#{man.name}</option>"
      }
    end
    select_tag "report_manufacturer_ids[]", options, :id => 'report_manufacturer_ids', :style=>"margin: 0 0 0 23px; height: 80px;", :multiple => true
  end
  
  def number_of_reviews_select(selected=nil)
    options=""
    ProductReport::NumberOfReviewsOptions.each{|opt|
      options += "<option value=#{opt[:id]}#{" SELECTED" if selected==opt[:id] || (selected.nil? && opt[:id] == 5)}>#{opt[:name]}</option>"  
    }
    select_tag "product_report[number_of_reviews]", options, :style=>"margin: 0 0 0 23px;"    
  end

  def nps_select(selected=nil)
    options=""
    NpsReport::NpsOptions.each{|opt|
      options += "<option value=#{opt[:id]}#{" SELECTED" if selected==opt[:id] || (selected.nil? && opt[:id] == 1)}>#{opt[:name]}</option>"
    }
    select_tag "product_report[nps_range]", options, :style=>"margin: 0 0 0 23px;"
  end
  
  def last_updated_filter_select(selected=nil)
    options=""
    ProductReport::LAST_UPDATED_FILTER_OPTIONS.each{|opt|
      options += "<option value=#{opt[:id]}#{" SELECTED" if selected==opt[:id] || (selected.nil? && opt[:id] == 5)}>#{opt[:name]}</option>"
    }
    select_tag "product_report[last_updated_filter]", options, :style=>"margin: 0 0 0 23px;"    
  end

  def rating_select(name, selected=nil)
    options=""
    ProductReport::RatingOptions.each{|opt|
      options += "<option value=#{opt[:id]}#{" SELECTED" if selected==opt[:id]}>#{opt[:name]}</option>"  
    }
    select_tag "product_report[#{name}]", options, :style=>"margin: 0 0 0 23px;"    
  end
  
  def sort_method_select(selected=nil)
    options=""
    ProductReport::SortMethod.each{|opt|
      options += "<option value=#{opt[:id]}#{" SELECTED" if selected==opt[:id]}>#{opt[:name]}</option>"  
    }
    select_tag "product_report[sorting_field]", options, :style=>"margin: 0 0 0 23px;"
  end

  def sort_method_select_nps(selected=nil)
    options=""
    NpsReport::SortMethodNps.each{|opt|
      options += "<option value=#{opt[:id]}#{" SELECTED" if selected==opt[:id]}>#{opt[:name]}</option>"
    }
    select_tag "product_report[sorting_field]", options, :style=>"margin: 0 0 0 23px;"
  end
  
  def sort_order_select(selected=nil)
    options=""
    NpsReport::SortOrder.each{|opt|
      options += "<option value=#{opt[:id]}#{" SELECTED" if selected==opt[:id]}>#{opt[:name]}</option>"  
    }
    select_tag "product_report[sorting_order]", options, :style=>"margin: 0 0 0 23px;"
  end


  
  def column_sort_icon(order)
    "<img src=\"/images/sort_icons#{order == 1 ? '_up' : '_down'}.png\">"
  end
  
end
