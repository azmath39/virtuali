class Payment < ActiveRecord::Base
   attr_accessible :type, :amount, :user_id, :reference
   belongs_to :user
end
