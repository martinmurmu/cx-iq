class TrendingProductReportMailingJob < Struct.new(:product_group_id, :user_id, :threshold, :mapping)
  def perform
    ReportsDispatcher.deliver_trending_products_report(product_group_id, user_id, threshold, mapping)
  end
end