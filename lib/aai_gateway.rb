class AaiGateway
  
  def self.product_lookup(query, query_type, user_id, page, per_page = 20, sort = "relevancy")
    url = URI.parse("#{APP_CONFIG[:main_aai_site_url]}")
    http_url = URI.encode("#{APP_CONFIG[:main_aai_site_url_postfix]}/seam/resource/services-v1/search/product?query=#{query}&querytype=#{query_type}&userid=#{user_id}&pageSize=#{per_page}&pageNum=#{page}&sort=#{sort}")
    puts http_url
    puts url.host
    puts url.port
    res = Net::HTTP.start(url.host, url.port) {|http|
       http.get(http_url)
    }
    res = JSON.parse res.body
    rows = res["products"].blank? ? [] : res["products"]

    WillPaginate::Collection.create(page, per_page) do |pager|
      result = rows
      pager.replace(result)
      pager.total_entries = res["resultCount"].to_i
    end
  end

  def self.psa_request(user_id, product_id)
    url = URI.parse("http://svc2.amplifiedanalytics.com")
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get(URI.encode("/seam/resource/services-v1/opinion/product?product=#{product_id}&user=#{user_id}"))
    }
    res
  end
  
end