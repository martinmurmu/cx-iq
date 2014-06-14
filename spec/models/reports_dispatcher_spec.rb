require 'spec_helper'

describe ReportsDispatcher do

  describe 'schedule' do
    it 'should create user usage' do
      report = Factory(:product_report)
      usage = Factory(:sent_report, :user=>report.user, :usage=>report)
      lambda{
        ReportsDispatcher.schedule_delivery(report, report.user, :pdf)
      }.should change(SentReport, :count).by(1)
    end
  end

  describe 'deliver' do
    it 'should update user usage sent timestamp' do
      report = Factory(:product_report)
      usage = Factory(:sent_report, :user=>report.user, :usage=>report)
      report.user.sent_reports.find(:last)[:sent_at].should be_nil
      UserMailer.should_receive(:deliver_product_report)

      ReportsDispatcher.deliver(usage.id)

      report.user.sent_reports.find(:last)[:sent_at].should_not be_nil
    end
  end

end
