class Activity < ActiveRecord::Base
  attr_accessible :activity_type, :adjustable_amount, :user_id
end
