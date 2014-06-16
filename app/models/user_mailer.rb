class UserMailer < ActionMailer::Base 
  def product_report(user, report, output_format)
    recipients  user.email
    from        "support@amplifiedanalytics.com"
    subject     "Report"
    body        :user => user
    
    if output_format == 'pdf'
      attachment "application/pdf" do |a|
        a.body = report.generate_pdf(user)
        a.filename = "Requested Information from AAI.pdf"
      end
    elsif  output_format == 'csv'
      attachment "application/csv" do |a|
        a.body = report.generate_csv
        a.filename = "Requested Information from AAI.csv"
      end  
    end
  end

  def psa_report_completion(user, url)
    recipients  user.email
    from        "support@amplifiedanalytics.com"
    subject     "PSA Report"
    body        :url => url

  end

  def cia_report(user, url,host,product_group_id)
    recipients  user.email
    from        "support@amplifiedanalytics.com"
    subject     "Market Report"
    body        :url => url, :host => host, :product_group_id=>product_group_id
  end

  def trending_report(user, url)
    recipients  user.email
    from        "support@amplifiedanalytics.com"
    subject     "Trending Report"
    body        :url => url
  end

  def trending_products_report(user, url)
    recipients  user.email
    from        "support@amplifiedanalytics.com"
    subject     "Trending Product Report"
    body        :url => url
  end
  
  def paper_download(paper_download)
    recipients  paper_download.email
    from        "support@amplifiedanalytics.com"
    subject     "White Paper Download"
    body        :paper_download => paper_download
  end
  
  def paper_download_info(paper_download)
    recipients  "greg@amplifiedanalytics.com"
    from        "support@amplifiedanalytics.com"
    subject     "White Paper Download By A User"
    body        :paper_download => paper_download
  end

end