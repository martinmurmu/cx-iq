class Review < ActiveRecord::Base
  set_table_name "review"
  belongs_to :product

	def create_review
		self.id = Digest::MD5.hexdigest(Time.now.strftime("%s%y%Y%d") + rand(Time.now.to_i).to_s + self.product_id.to_s)
		self.save
	end

end
