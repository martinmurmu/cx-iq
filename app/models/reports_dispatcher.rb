class ReportsDispatcher

  def self.schedule_delivery(report, user, report_format)
    usage = report.sent_reports.build(:user => user, :output_format => report_format.to_s, :category => report.product_category)
    usage.complimentary = true if user.sent_reports.size == 0
    usage.save!
    Delayed::Job.enqueue(MailingJob.new(usage.id))
  end


  def self.deliver(usage_id)
    usage = SentReport.find usage_id
    UserMailer.deliver_product_report(usage.user, usage.usage, usage.output_format)
    usage.update_attribute('sent_at', Time.now.utc)
  end

  def self.deliver_cia_report(product_group_id, user_id, threshold, mapping, host)
    Rails.logger.info "deliver_cia_report"
    user = User.find user_id
    group = user.product_groups.find product_group_id
    begin
      report = CiaReportGenerator.new(:user_id => user_id, :product_ids => group.product_ids)
      report_urls = report.run(threshold, mapping)
      output_map = ReportGenerator.process_output_map(report_urls[:map_output])
      group.update_attribute 'keywords', ReportGenerator.process_output_map(report_urls[:map_output]) unless output_map.blank?
      UserMailer.deliver_cia_report(user, "#{report_urls[:user_id]}/#{report_urls[:time]}/#{report_urls[:product_id]}",host,product_group_id)
    rescue => e
      Rails.logger.info e.message
      UserMailer.deliver_cia_report(user, "[BUILDING REPORT FAILED]",host,product_group_id)
    end
    
  end

  def self.deliver_trending_report(product_id, user_id, threshold, mapping)
    user = User.find user_id
    product = user.my_products.find{|x| x.attributes['id'] == product_id}
    report_url = TrendingReportGenerator.new(:user_id => user_id, :product_id => product.attributes['id']).run(threshold, mapping)
    UserMailer.deliver_trending_report(user, report_url)
  end

  def self.deliver_trending_products_report(product_group_id, user_id, threshold, mapping)
    user = User.find user_id
    report_gen = TrendingReportProducts.new({:user_id => user_id, :product_group_id => product_group_id})
    report_url = report_gen.run
    UserMailer.deliver_trending_products_report(user, report_url)
  end


end
