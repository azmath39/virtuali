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
  delegate :email,:name,:to=>:user, :prefix => true
# def user_name
#   self.user.name
# end
# def user_email
# end

  def opinion
    case self.satisfaction_status
    when 'yes'
      'Satisfied'
    when 'no'
      'UnSatisfied'
    end
  end
end
