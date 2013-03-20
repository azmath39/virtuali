class Coupon < ActiveRecord::Base
  
  attr_accessible :code, :company, :company_email, :expire_date, :valid_date,:value
  has_many :user, :through=>:assigned_coupons
  has_many :assigned_coupons, :dependent => :destroy
  has_many :user, :through=>:coupon_transactions
  has_many :coupon_transactions
  validate :code, :presence=>true, :uniqueness=>true
  #uniquify  :code
  #    uniquify :code do
  #      rand(999999)
  #    end
  before_create :generate_code

def generate_code
    begin
        code = SecureRandom.hex(4)
    end while Coupon.where(:code => code).exists?
    self.code = code
end
end
