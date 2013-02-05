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
#

class SelectedPackage < ActiveRecord::Base
  attr_accessible :package_id, :price, :user_id
  belongs_to :user
  belongs_to :package
end
