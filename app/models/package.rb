# == Schema Information
#
# Table name: packages
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  product_id          :integer
#  pictures_for_tour   :integer
#  status              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  subscription_period :integer
#  add_on              :integer
#  monthly_price       :float
#  yearly_price        :float
#  no_of_tours         :integer
#

class Package < ActiveRecord::Base
  attr_accessible :name, :pictures_for_tour, :monthly_price,:yearly_price,:no_of_tours, :product_id, :status,:subscription_period,:add_on
  has_many :users, :through => :selected_packages
  has_many :selected_packages
  belongs_to :product
  def max_tours
    case self.no_of_tours
    when 0
      "Unlimited"
    when 1
      1
    else
      1
    end
  end
  def price
    if self.monthly_price.nil?
      "$#{self.yearly_price}/year"  
    else
      "$#{self.monthly_price} per month"

    end
  end
end
