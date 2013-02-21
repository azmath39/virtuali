class Card < ActiveRecord::Base
  attr_accessible :customer_stripe_id, :user_id
  belongs_to :user
end
