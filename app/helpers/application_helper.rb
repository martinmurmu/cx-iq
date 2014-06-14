# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def filter_link name,value,caption
    ret = cur_params
    selected = ""
    if ret[name]==value || (value.nil? && !(ret.has_key? name))
      selected =" class='selected' "
    end
    if value.nil?
      ret.delete(name)
    else
      ret[name] = value
    end
    raw("<a href=?#{ret.to_query} #{selected}>#{caption}</a>")
  end

  def filter_clear filter_names, caption
    ret = cur_params
    selected = " class='selected' "
    filter_names.each { |name|
      if ret.has_key? name
        selected = ""
      end
      ret.delete(name)
    }

    raw("<a href=?#{ret.to_query} #{selected}>#{caption}</a>")
  end

  def cur_params
    ret = params.clone
    ret.delete(:action)
    ret.delete(:controller)
    ret
  end


  def v2p_widget_dial_image(product, score)
    img='0.0'
    unless product.blank?
      score = product.send(score.to_sym)
      unless score.blank?
        img = (score*10).round.to_f/10
        img = img.to_s
      end
    end
    "<img alt=\"#{img}\" src=\"/images/widget/dial/#{img}.gif\">"
  end

  def page_title
    @page_title.blank? ? "Amplified Analytics" : @page_title
  end

  def default_content_for(name, &block)
    name = name.kind_of?(Symbol) ? ":#{name}" : name
    out = eval("yield #{name}", block.binding)
    concat(out || capture(&block))
  end

  def page_title
    @page_title.blank? ? "Home of Consumer Reports - Amplified Analytics" : @page_title
  end

  def nice_captcha options = {}
    render :partial => "js_helpers/nice_captcha",
      :locals => {:options => options}
  end

  def link_customize_cia_report(product, current_user)
    unless current_user.paying_customer?
      "#cust-msg"
    else
      produce_psa_report_settings_product_path(product)
    end
  end

	def seemorebutton_link(cookies, current_user)
		if current_user.guest?
			if cookies[:ciareport_guest] == "true"
				can_view = false
				@popup_msg = "Please <b><a href='/users/sign_up'>Register</a></b> to see this report again"
			else
				can_view = true
			end
		elsif !current_user.paying_customer?
			if cookies[:ciareport_unpaying_cust].to_i == 3
				can_view = false
				@popup_msg = "Please <b><a href='/Contact-Us'>contact us</a></b> to purchase this report"
			else
				can_view = true
			end
		else
			can_view = true
		end

		if can_view
			image_submit_tag("/images/seemoredetailsButton.png", :id => "seemorebutton")
		else
			@popup = true
			link_to(image_tag("/images/seemoredetailsButton.png", :id => "seemorebutton"), "#popup-msg", {:id => "seemorebutton-link"})
		end


	end

  def generate_link_reviews_product_quater(labels, title = "")

    reviews_link = {}
    labels.each_with_index do |label, i|
      label.each do |l|
        reviews_link[l] = [] unless reviews_link.has_key?(l)
        reviews_link[l] << session[:product_cols][i]
      end
    end

    res = "<div class='period_links'>"
    labels.flatten.uniq.each do |quater|
      res += "<div class=period_link>"
      res += "#{quater}<br />"
      reviews_link[quater].each do |q|
        path = "#{q[:path]}/#{quater}.html#{title == "" ? "" : "#" + title}"
        res += "<a href='/newreports/product_reviews?product_name=#{CGI.escape(q[:product])}&url_review=#{path}' target='_blank' title='#{q[:product]}'>"
        res += "<div style='margin-right: 2px;border: 1px black solid; background-color: ##{q[:colours]}; width: 17px; height: 17px; float: left'></div>"
        res += "</a>"
      end
      res += "</div>"
    end
    res += "</div>"
    res
  end

end
