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

  attr_accessible :image, :name, :pro

  belongs_to :tour

  #belongs_to :paintable, :polymorphic => true
  mount_uploader :image, ImageUploader
  before_create :default_name

#  before_update :reprocess_image, :if => :cropping?

#  def cropping?
#    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
#  end
  def default_name
    self.name ||= File.basename(image.filename, '.*').titleize if image
  end
def pro=(a)
sat=a["saturate"].to_i + 100
   #bright=(a["brightness"].to_i )*20  /100
#bright = a["brightness"].to_f*0.075
puts "ndkvhdkgdf"
   puts "convert #{Rails.root}/public#{self.image.url} -brightness-contrast #{a["brightness"].to_i},#{a["contrast"].to_i} -set option:modulate:colorspace hsb -modulate 100,#{sat} #{Rails.root}/public#{self.image.url}"
 puts "ndkvhdkgdf"
 puts "ndkvhdkgdf"
system <<-COMMAND
convert #{Rails.root}/public#{self.image.url} -brightness-contrast #{a["brightness"].to_i},#{a["contrast"].to_i} -set option:modulate:colorspace hsb -modulate 100,#{sat} #{Rails.root}/public#{self.image.url}
 convert #{Rails.root}/public#{self.image.url(:thumb)} -brightness-contrast #{a["brightness"].to_i},#{a["contrast"].to_i} -set option:modulate:colorspace hsb -modulate 100,#{sat} #{Rails.root}/public#{self.image.url(:thumb)}
  convert #{Rails.root}/public#{self.image.url(:small)} -brightness-contrast #{a["brightness"].to_i},#{a["contrast"].to_i} -set option:modulate:colorspace hsb -modulate 100,#{sat} #{Rails.root}/public#{self.image.url(:small)}
  convert #{Rails.root}/public#{self.image.url(:medium)} -brightness-contrast #{a["brightness"].to_i},#{a["contrast"].to_i} -set option:modulate:colorspace hsb -modulate 100,#{sat} #{Rails.root}/public#{self.image.url(:medium)}
 convert #{Rails.root}/public#{self.image.url(:large)} -brightness-contrast #{a["brightness"].to_i},#{a["contrast"].to_i} -set option:modulate:colorspace hsb -modulate 100,#{sat} #{Rails.root}/public#{self.image.url(:large)}
  COMMAND


   end

#  private
#  def reprocess_image
#    image.reprocess!
#  end
end
