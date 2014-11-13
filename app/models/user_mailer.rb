class UserMailer < ActionMailer::Base 
  def product_report(user, report, output_format)
    @user = user
    
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

    mail(
      to: user.email,
      from: "support@amplifiedanalytics.com",
      subject: "Report"
    )
  end

  def psa_report_completion(user, url)
    @url = url
    mail(
      to: user.email,
      from: "support@amplifiedanalytics.com",
      subject: "PSA Report"
    )

  end

  def cia_report(user, url,host,product_group_id)
    @url = url
    @host = host
    @product_group_id= product_group_id

    mail(
      to: user.email,
      from: "support@amplifiedanalytics.com",
      subject: "Market Report"
    )
  end

  def trending_report(user, url)
    @url = url
    mail(
      to: user.email,
      from: "support@amplifiedanalytics.com",
      subject: "Trending Report"
    )
  end

  def trending_products_report(user, url)
    @url = url
    mail(
      to: user.email,
      from: "support@amplifiedanalytics.com",
      subject: "Trending Product Report"
    )
  end
  
  def paper_download(paper_download)
    @paper_download = paper_download
    mail(
      to: paper_download.email,
      from: "support@amplifiedanalytics.com",
      subject: "White Paper Download"
    )
  end
  
  def paper_download_info(paper_download)
    @paper_download = paper_download
    mail(
      to: "greg@amplifiedanalytics.com",
      from: "support@amplifiedanalytics.com",
      subject: "White Paper Download By A User"
    )
  end

end
