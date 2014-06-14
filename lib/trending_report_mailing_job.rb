class TrendingReportMailingJob < Struct.new(:product_id, :user_id, :threshold, :mapping)
  def perform
    ReportsDispatcher.deliver_trending_report(product_id, user_id, threshold, mapping)
  end
end