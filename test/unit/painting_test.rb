# == Schema Information
#
# Table name: paintings
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  image           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :integer
#  attachable_type :string(255)
#  tour_id         :integer
#

require 'test_helper'

class PaintingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
