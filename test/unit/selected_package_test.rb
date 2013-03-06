# == Schema Information
#
# Table name: selected_packages
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  package_id          :integer
#  price               :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  status              :integer
#  expire_date         :date
#  pictures_for_tour   :integer
#  payment_period_type :integer
#  renew_date          :date
#

require 'test_helper'

class SelectedPackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
