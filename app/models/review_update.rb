class ReviewUpdate < ActiveRecord::Base
  belongs_to :product

  def self.send_updates
    users_to_notify = {}
    Product.active_products.each{|p|
      recent_review = p.recent_review
      previous_update = ReviewUpdate.find(:first, :conditions => ["product_id = ?", p.id], :order => 'id desc')
      if !recent_review.blank? && !recent_review.recieve_date.blank?
        if (previous_update.blank? && p.number_of_reviews >0) || (!previous_update.blank? && (previous_update.last_updated_at != recent_review.recieve_date || previous_update.number_of_reviews != p.number_of_reviews))
          users = User.find_by_sql(["SELECT DISTINCT(users.id) FROM users, product_groups, product_groupings where product_groupings.product_group_id = product_groups.id AND product_groups.user_id = users.id AND product_groupings.product_id = ?", p.attributes['id']])
          users.each{|user|
            if users_to_notify[user.id].blank?
              users_to_notify[user.id] = [p.attributes['id']]
            else
              users_to_notify[user.id] << p.attributes['id']
            end
          }
        end
        if previous_update.blank? || previous_update.last_updated_at != recent_review.recieve_date || previous_update.number_of_reviews != p.number_of_reviews
          ReviewUpdate.create(:product_id => p.id, :last_updated_at => recent_review.recieve_date, :number_of_reviews => p.number_of_reviews)
        end        
      end
    }

#    p users_to_notify

    users_to_notify.each{|user, products|
      u = User.find(user)
      Emailer.deliver_product_update(u, products) if u.send_review_updates? 
    }
  end
end
