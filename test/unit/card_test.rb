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

require 'test_helper'

class CardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
