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
  attr_accessible :package_id, :price, :user_id,:status
  belongs_to :user
  belongs_to :package
  before_create :asign_status, :set_expire_date
  has_many :tour
  def asign_status
   # puts "S"*25
    self.status ||=0
  end
  def set_expire_date
    self.expire_date ||=Date.today+30
  end
  
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

end
