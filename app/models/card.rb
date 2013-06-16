# == Schema Information
#
# Table name: cards
#
#  id                 :integer          not null, primary key
#  customer_stripe_id :string(255)
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Card < ActiveRecord::Base
  attr_accessible :subcription_id, :user_id
  belongs_to :user
end
