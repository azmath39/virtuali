class Coupon < ActiveRecord::Base
  
  attr_accessible :code, :company, :company_email, :expire_date, :valid_date,:value
  has_one :user, :through=>:assigned_coupon
  has_one :assigned_coupon, :dependent => :destroy
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
