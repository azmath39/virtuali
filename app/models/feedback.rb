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

class Feedback < ActiveRecord::Base
  attr_accessible :content, :satisfaction_status
  belongs_to :user
  scope :recent, :limit => 5, :order => 'created_at DESC'
  delegate :email, :to => :user, :prefix => true
end
