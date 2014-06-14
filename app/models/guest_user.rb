class GuestUser

  attr_accessor :product_report_id
  
  def id
    0
  end
  
  def guest?
    true
  end

  def admin?
    false
  end
  
  def categories_subscriptions_allowed
    1
  end

  def categories
    @subscriptions.blank? ? [] : Category.find(@subscriptions) 
  end

  def subscribed?(category)
    @subscriptions.blank? ? false : @subscriptions.include?(category.id)
  end

  def subscriptions
    @subscriptions.blank? ? [] : @subscriptions
  end

  def subscriptions=(subs)
    @subscriptions = subs
  end
  
  def product_reports
    @product_report_id.blank? ? [] : ProductReport.find(@product_report_id)
  end

  def product_report
    @product_report_id.blank? ? nil : ProductReport.find(@product_report_id)
  end

  def allowed_to_generate_report?(*args)
    false
  end

  def product_groups
    []
  end

  def paying_customer?
    false
  end

end
