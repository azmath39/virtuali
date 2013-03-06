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
  attr_accessible :package_id, :price, :user_id,:status,:pictures_for_tour,:payment_period_type
  belongs_to :user
  belongs_to :package
  after_initialize :assign_status_expire_date_payment_period_type
  after_create :set_renew_date_and_package_price
  has_many :tour
  # == call back
  def assign_status_expire_date_payment_period_type
    # puts "S"*25
    self.status ||=0
    self.expire_date ||=Date.today+365
    self.payment_period_type ||=2
  end
  def set_renew_date_and_package_price
    if self.payment_period_type==1
      self.renew_date ||= self.created_at.to_date+30
      self.price=self.package.monthly_price
    else
      self.renew_date ||= self.created_at.to_date+365
      self.price=self.package.yearly_price
    end
    self.save
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
      "Renwed"
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
      "expired"
    when 3
      "Sold"
    end
  end
  def tours_enable
    if self.update_attributes(:status=>1) then
      tours=self.user.tours
      unless tours.empty?
        tours.each do |tour|
          tour.update_attributes(:status=>1)
        end
        unless self.user.user_delay_job.nil? then
          dl_job=self.user.user_delay_job.delayed_job
          dl_job.destroy unless dl_job.nil?
        end
        self.user.set_auto_destroy_event
      end
      true
    else
      false
    end
  end
  def tours_disable
    self.update_attributes(:status=>2)
    
    tours=self.user.tours
    unless tours.empty?
      tours.each do |tour|
        tour.update_attributes(:status=>2)
      end
      d =Delayed::Job.enqueue TourDestroy.new(self.id),:priority=>0, :run_at=>15.day.from_now
      self.user.user_delay_job.update_attributes(:delayed_job_id=>d.id)
      #      #Delayed::Job.enqueue TourDestroy.new(self.id),0, 1.minute.from_now
      #      Delayed::Job.enqueue TourDestroy.new(self.id),:priority=>0, :run_at=>self.validity
    end
  end
 

  def tours_destroy
    #self.update_attributes(:status=>3)
    tours=self.user.tours
    unless tours.empty?
      self.user.tours.each do |tour|
        tour.destroy
      end
    end
    self.user.user_delay_job.destroy
  end
  
  def send_alert_message

  end
  def subscribed_days
    if self.payment_period_type==1
      30
    else
      365
    end
  end
  def validity
    if self.payment_period_type==1
      30.days.from_now
    else
      365.days.from_now
    end
  end
end
