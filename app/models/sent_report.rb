class SentReport < ActiveRecord::Base
  belongs_to :usage, :polymorphic => true
  belongs_to :user

  belongs_to :category, :polymorphic => true

  validates_presence_of :user_id, :usage_id, :usage_type


  default_value_for :complimentary, false
end
