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

class SelectedPackage < ActiveRecord::Base
  #require 'tours_jobs'
  attr_accessible :package_id, :price, :user_id,:status,:pictures_for_tour,:payment_period_type,:renew_date,:created_at
  belongs_to :user
  belongs_to :package
  after_initialize :assign_status_expire_date_payment_period_type
  after_create :set_renew_date_and_package_price
  has_many :tour
  # == call back
  delegate :name, :pictures_for_tour, :status, :subscription_period, :add_on, :regular_price, :special_price, :no_of_tours, :to => :package, :prefix => true
  def assign_status_expire_date_payment_period_type
    # puts "S"*25
    self.status ||=1
    self.expire_date ||=Date.today+365
    self.payment_period_type ||=3
  end
  def set_renew_date_and_package_price
    self.renew_date ||= self.created_at.to_date+self.subscribed_days
    case self.payment_period_type
    when 2
      self.price=self.package.special_price
    else
      self.price=self.package.regular_price
    end
    self.save
  end
def renew_package

  self.renew_date += self.subscribed_days
  user.adjust_balance
  self.save
  tours_enable
  self.user.set_auto_destroy_event
end

  def tours_enable
    self.update_attributes(:status=>1) unless self.status==1
      tours=self.user.tours.where('status!=:status',:status=>1)
      unless tours.empty?
        tours.each do |tour|
          tour.update_attributes(:status=>1)
        end
      end

  end
  def disable
    self.update_attributes(:status=>2)
    self.user.tours_disable
    d =Delayed::Job.enqueue TourDestroy.new(self.user.id),:priority=>0, :run_at=>10.day.from_now

    self.user.user_delay_job.update_attributes(:delayed_job_id=>d.id)
    msg="Your account Subscription as expired. All your tour are been Disabled and will be deleted after 10 day from now. Immediatly, renew your package  within 10 days to keep your tours safe."
     self.user.send_message("Important Alert!",msg);
  end

  def package_destroy
    self.update_attributes(:status=>2) unless self.status==2
    self.user.tours_destroy
    #d =Delayed::Job.enqueue UserDestroy.new(self.user.id),:priority=>0, :run_at=>30.day.from_now
    #self.user.user_delay_job.update_attributes(:delayed_job_id=>d.id)
    
    # self.user.destroy_delay_job

    #msg="All your tours are removed from virtuali and Your account will deleted after 30 day from now. Login into your Account and Purchase any package, to keep your account live. "
   # self.user.send_message("Important Alert!",msg);
  end
  def remaining_days
    (self.renew_date-Date.today).to_i
  end

  def subscribed_days
    case self.payment_period_type
    when 1
      30
    when 3
      90
    when 2
      365
    end
  end
  def validity
    ((self.renew_date-Date.today).to_i-5).day.from_now
  end
  # == Getters
  def name
    Package.find(package_id).name
  end

  def status_info
    case status
    when 0
      "New"
    when 1
      "Active"
    when 2
      "Expired"
    when 3
      "Unsubscribed"
    end
  end
  def tour_status
    status_tour = self.tour.status
    case status_tour
    when 1
      "Active"
    when 0
      "Pending"
    when 2
      "Disabled"
    when 3
      "Sold"
    when 4
      "In Active(need action)"
    end
  end


end
