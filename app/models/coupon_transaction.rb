class CouponTransaction < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :coupon
  belongs_to :user
  delegate :code,:value, :to=>:coupon, :prefix=>true
end
