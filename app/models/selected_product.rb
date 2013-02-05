# == Schema Information
#
# Table name: selected_products
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SelectedProduct < ActiveRecord::Base
  attr_accessible :product_id, :user_id
  belongs_to :user
  belongs_to :product
end
