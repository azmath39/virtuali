# == Schema Information
#
# Table name: delayed_jobs
#
#  id         :integer          not null, primary key
#  priority   :integer          default(0)
#  attempts   :integer          default(0)
#  handler    :text
#  last_error :text
#  run_at     :datetime
#  locked_at  :datetime
#  failed_at  :datetime
#  locked_by  :string(255)
#  queue      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

# To change this template, choose Tools | Templates
# and open the template in the editor.

class DelayedJob < ActiveRecord::Base
  
 has_one :user, :through=>:user_delay_job
 has_one :user_delay_job
end
