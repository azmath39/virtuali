class Draft < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :paintings
  belongs_to :user
  before_create :set_name,:send_tour_to_realtor
  def send_tour_to_realtor
  	if self.order_number.blank? && self.store_realtor.present?
     Tour.create_realtor self
   end
  end
  private
  def set_name
    self.name ||= DateTime.now.to_s
  end
end
