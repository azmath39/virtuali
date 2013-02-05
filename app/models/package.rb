# == Schema Information
#
# Table name: packages
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  price             :float
#  product_id        :integer
#  pictures_for_tour :integer
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  description       :text
#

class Package < ActiveRecord::Base
  attr_accessible :name, :pictures_for_tour, :price, :product_id, :status, :description
  has_many :users, :through => :selected_packages
  has_many :selected_packages
  belongs_to :user
end
