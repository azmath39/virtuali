# == Schema Information
#
# Table name: packages
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  product_id          :integer
#  pictures_for_tour   :integer
#  status              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  subscription_period :integer
#  add_on              :integer
#  monthly_price       :float
#  yearly_price        :float
#  no_of_tours         :integer
#

require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
