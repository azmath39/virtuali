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
  attr_accessible :package_id, :price, :user_id
  belongs_to :user
  belongs_to :package
  after_initialize :asign_status
  has_one :tour
  def asign_status
    self.status||=0
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
      "Deleted"
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
