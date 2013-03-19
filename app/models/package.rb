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
  attr_accessible :name, :pictures_for_tour, :regular_price,:special_price,:no_of_tours, :product_id,:package_type, :status,:subscription_period,:add_on
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
    if !self.special_price.nil? 
      "$#{self.regular_price}/month"
    else
      "$#{self.regular_price}/ 3 months"

    end
  end
end
