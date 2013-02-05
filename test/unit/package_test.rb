# == Schema Information
#
# Table name: packages
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  price             :float
#  product_id        :integer
#  pictures_for_tour :integer
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  description       :text
#

require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
