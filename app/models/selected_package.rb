# == Schema Information
#
# Table name: selected_packages
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  package_id :integer
#  price      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#

class SelectedPackage < ActiveRecord::Base
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
  def tours_disable
    self.update_attributes(:status=>2)
    tours=self.user.tours
    unless tours.empty?

      tours.each do |tour|
        tour.update_attributes(:status=>2)
      end
    end
  end
  def tours_destroy
    tours=self.user.tours
    unless tours.empty?
      self.user.tours.each do |tour|
        tour.destroy
      end
    end
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

end
