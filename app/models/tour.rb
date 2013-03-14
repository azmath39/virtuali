# == Schema Information
#
# Table name: tours
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  state               :string(255)
#  description         :string(255)
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  city                :string(255)
#  zip                 :string(255)
#  subdivision         :string(255)
#  price               :float
#  square_footage      :integer
#  bed_rooms           :integer
#  bath_rooms          :integer
#  category_id         :integer
#  latitude            :float
#  longitude           :float
#  gmaps               :boolean
#  slug                :string(255)
#  address             :text
#  status              :integer
#  selected_package_id :integer
#  deleted_at          :datetime
#


#  id             :integer          not null, primary key
#  name           :string(255)
#  state          :string(255)
#  description    :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  city           :string(255)
#  zip            :string(255)
#  subdivision    :string(255)
#  price          :float
#  square_footage :integer
#  bed_rooms      :integer
#  bath_rooms     :integer
#  category_id    :integer
#  latitude       :float
#  longitude      :float
#  gmaps          :boolean
#  status         :string(255)
#  slug           :string(255)
#  address        :text

#

class Tour < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :gmaps, :state, :description, :city, :zip, :subdivision, :price,:address1,:address2, :square_footage, :bed_rooms, :bath_rooms,:selected_package_id,:status
  #attr_accessor :pro
  acts_as_paranoid
  validates :state, :city, :zip, :subdivision, :price, :address1,:address2,:square_footage, :presence => true
  validates :price, :numericality => {:greater_than => 0}
  after_initialize :set_status
  before_create :set_address
  friendly_id :address, use: :slugged
  acts_as_gmappable
  belongs_to :user
  has_many :paintings, :dependent => :destroy
  belongs_to :category
  belongs_to :selected_package
  after_create :set_name
  def set_name
    self.name="#{self.state}%#{self.city}%#{self.zip}%#{self.subdivision}"
    self.save
  end
  def gmaps4rails_address
    "#{address1},#{address1},#{state}, #{city},#{zip}"
  end
def pro
  self.user.selected_product.product.name
end
  def set_status
    self.status ||= 1
  end
  def set_address
    self.address = "#{self.state}%#{self.city}%#{self.zip}%#{self.subdivision}"
  end
  def tour_name
    "#{self.state}%#{self.city}%#{self.zip}%#{self.subdivision}"
  end
  def tour_status
    case status
    when 1
      "Active"
    when 0
      "Pending"
    when 2
      "Disable"
    when 3
      "Sold"
    
    when 4
       "In Active (Action needed)"
    end
  end
  def validate_picture_count?
    if self.paintings.count.to_i <= self.user.selected_package.pictures_for_tour.to_i
      true
    else
      false
    end
  end
end
