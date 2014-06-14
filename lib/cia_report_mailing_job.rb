class CiaReportMailingJob < Struct.new(:product_group_id, :user_id, :threshold, :mapping, :host)
  def perform
    Delayed::Worker.logger.info "CiaReportMailingJob::perform"
    ReportsDispatcher.deliver_cia_report(product_group_id, user_id, threshold, mapping, host)
  end
end