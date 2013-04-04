# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Product < ActiveRecord::Base
  attr_accessible :name, :category_id, :product_type
  has_many :users, :through => :selected_products
  has_many :selected_products
  has_many :packages
  has_many :tours
  has_many :payments
  belongs_to :category
  def product_type_to_string
    case self.product_type.to_i
    when 1
      "Regular"
    when 2
      "Combo"
    end
  end
  def sum_payments
    self.payments.sum(:amount)
  end
  def users_count
    self.selected_products.count
  end
  def promoted_subscriptions
    self.selected_products.collect{|s| s.user.coupon_transactions.count}.inject(:+)
  end
  def subscriptions
    self.payments.count
  end
end
