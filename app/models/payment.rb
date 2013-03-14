class Payment < ActiveRecord::Base
   attr_accessible :payment_type, :amount, :user_id, :reference
   belongs_to :user
   def payment_type_info
     case self.payment_type
     when 1
         "Card Payment"
     when 2
          "Direct Debit"
     when 3
         "1st Direct Debit"
     when 4
         "Refunded"
     end
   end
   def user_name
     self.user.name unless self.user.nil?
   end
   def user_email
     self.user.email unless self.user.nil?
   end
end
