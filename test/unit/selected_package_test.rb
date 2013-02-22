# == Schema Information
#
# Table name: selected_packages
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  package_id :integer
#  price      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#

require 'test_helper'

class SelectedPackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
