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
     end
   end
   def user_name
     self.user.name
   end
   def user_email
     self.user.email
   end
end
