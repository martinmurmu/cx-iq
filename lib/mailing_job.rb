class MailingJob < Struct.new(:sent_report_id)
  def perform
    ReportsDispatcher.deliver(sent_report_id)
  end
end