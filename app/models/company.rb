class Company < ActiveRecord::Base
  attr_accessible :address, :logo, :name, :phno
  belongs_to :user
  mount_uploader :logo, ImageUploader
end
