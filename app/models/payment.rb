class Payment < ActiveRecord::Base
  attr_accessible :payment_type, :amount, :user_id, :reference,:product_id,:name,:email
  belongs_to :user
  belongs_to :product
  scope :recent, :limit => 5, :order => 'created_at DESC'
  
  def payment_type_info
    self.payment_type
#    case self.payment_type
#    when 1
#      "Card Payment"
#    when 2
#      "Direct Debit"
#    when 3
#      "1st Direct Debit"
#    when 4
#      "Refunded"
#    end
  end
  
#  def user_name
#    self.user.name unless self.user.nil?
#  end
#  def user_email
#    self.user.email unless self.user.nil?
#  end
 
end
#class PaymentDecorator < ApplicationDecorator
#    decorates :name
#
##    def image
##      h.image_tag model.image_url
##    end
#  end
