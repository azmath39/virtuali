class UserDelayJob < ActiveRecord::Base
 belongs_to :delayed_job
 belongs_to :user
end
