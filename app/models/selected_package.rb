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
    self.status ||=1
    self.expire_date ||=Date.today+365
    self.payment_period_type ||=3
  end
  def set_renew_date_and_package_price
    self.renew_date ||= self.created_at.to_date+self.subscribed_days
    case self.payment_period_type
    when 3
      self.price=self.package.special_price
    else
      self.price=self.package.regular_price
    end
    self.save
  end

  def tours_enable
    if self.update_attributes(:status=>1) then
      tours=self.user.tours
      unless tours.empty?
        tours.each do |tour|
          tour.update_attributes(:status=>1)
        end
        
        self.user.set_auto_destroy_event
      end
      true
    else
      false
    end
  end
  def disable
    self.update_attributes(:status=>2)
   self.user.tours_disable
  end

  def _destroy
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
  #  def remaining_days
  #    (self.renew_date-Date.today).to_i
  #  end
  def subscribed_days
    case self.payment_period_type
    when 1
      30
    when 2
      90
    when 3
      365
    end
  end
  def validity
    (self.renew_date-Date.today).to_i
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
      "expired"
    when 3
      "Sold"
    when 4
      "In Active(need action)"
    end
  end


end
