class Emailer < ActionMailer::Base
  def contact(recipient, subject, message, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
    @from = 'no-reply@amplifiedanalytics.com'
    @sent_on = sent_at
    @body["title"] = 'AAI Contact Us form submission'
    @body["message"] = message
    @headers = {}
  end

  def wom_request(recipient, subject, message, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
    @from = 'no-reply@amplifiedanalytics.com'
    @sent_on = sent_at
    @body["title"] = 'WOM request form submission'
    @body["message"] = message
    @headers = {}
  end
  

  def new_user(recipient, subject, message, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
    @from = 'no-reply@amplifiedanalytics.com'
    @sent_on = sent_at
    @body["title"] = 'New user registration'
    @body["message"] = message
    @headers = {}    
  end

  def product_update(user, products)
    @products = products
    @recipients = user.email
    @user = user
    @from = 'no-reply@amplifiedanalytics.com'
    subject     "New customer feedback for your products"
    content_type "text/html"
  end
  
  def product_submit(recipient, subject, params)
    @subject = subject     
    @recipients = recipient
    @from = 'no-reply@amplifiedanalytics.com'
    @sent_on = Time.now
    @body['title'] = 'Product Submit'
    @params = params
    @headers = {}
    content_type "text/html"
  end
  

end
