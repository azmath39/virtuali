# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  image                  :string(255)
#  name                   :string(255)
#  phno                   :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  attr_accessible :name, :phno, :email, :password, :password_confirmation, :remember_me, :image,:product,:package


  mount_uploader :image, ImageUploader
  has_many :tours, :dependent => :destroy
  has_many :products, :through => :selected_products
  has_many :selected_products
  has_many :packages, :through => :selected_packages
  has_many :selected_packages
  has_one :card
  has_many :feedbacks, :dependent => :destroy
has_many :paintings, :dependent=>:destroy


  def package=(pkg)
    unless pkg.nil?
     
        p=Package.find(pkg.to_i)
        self.selected_packages<<SelectedPackage.create(:package_id=>p.id,:price=>p.price)
     
    end
  end
  def product=(pro)
    unless pro.nil?
        self.selected_products<<SelectedProduct.create(:product_id=>pro.to_i)
    end
  end

end
