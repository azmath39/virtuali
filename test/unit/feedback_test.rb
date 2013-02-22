# == Schema Information
#
# Table name: feedbacks
#
#  id                  :integer          not null, primary key
#  satisfaction_status :string(255)
#  content             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer
#

require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
