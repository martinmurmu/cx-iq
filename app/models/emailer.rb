class Emailer < ActionMailer::Base
  def contact(recipient, subject, message, sent_at = Time.now)
    @sent_on = sent_at
    @title = 'AAI Contact Us form submission'
    @message = message
    @headers = {}
    mail(
      subject: subject,
      to: recipient,
      from: 'no-reply@amplifiedanalytics.com'
    )
  end

  def wom_request(recipient, subject, message, sent_at = Time.now)
    @sent_on = sent_at
    @title = 'WOM request form submission'
    @message = message
    @headers = {}
    mail(
      subject: subject,
      to: recipient,
      from: 'no-reply@amplifiedanalytics.com'
    )
  end
  

  def new_user(recipient, subject, message, sent_at = Time.now)
    @sent_on = sent_at
    @title = 'New user registration'
    @message = message
    @headers = {}    
    mail(
      subject: subject,
      recipients: recipient,
      from: 'no-reply@amplifiedanalytics.com'
    )
  end

  def product_update(user, products)
    @products = products
    @user = user
    mail(
      to: user.email,
      from: 'no-reply@amplifiedanalytics.com',
      subject: "New customer feedback for your products",
      content_type: "text/html"
    )
  end
  
  def product_submit(recipient, subject, params)
    @sent_on = Time.now
    @body['title'] = 'Product Submit'
    @params = params
    @headers = {}
    mail(
      subject: subject,
      to: recipient,
      from: 'no-reply@amplifiedanalytics.com',
      content_type: "text/html"
    )
  end
  

end
