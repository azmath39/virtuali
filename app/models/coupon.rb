class Coupon < ActiveRecord::Base
  
  attr_accessible :code, :company, :company_email, :expire_date, :valid_date,:value
  has_one :user, :through=>:assigned_coupon
  has_one :assigned_coupon, :dependent => :destroy
  
  #uniquify  :code
  
    uniquify :code do
      rand(999999)
    end
  
end
