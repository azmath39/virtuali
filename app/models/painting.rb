# == Schema Information
#
# Table name: paintings
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  image          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tour_id        :integer
#  paintable_id   :integer
#  paintable_type :string(255)
#

class Painting < ActiveRecord::Base
 # include Gmaps4rails::ActsAsGmappable
  attr_accessible :image, :name
#  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
#  mount_uploader :image, ImageUploader
  belongs_to :tour
  belongs_to :paintable, :polymorphic => true
  mount_uploader :image, ImageUploader
  before_create :default_name
#  before_update :reprocess_image, :if => :cropping?

#  def cropping?
#    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
#  end
  def default_name
    self.name ||= File.basename(image.filename, '.*').titleize if image
  end

#  private
#  def reprocess_image
#    image.reprocess!
#  end
end
