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
  
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  attr_accessible :name, :phno, :email, :password, :password_confirmation, :remember_me, :image,:product,:package


  mount_uploader :image, ImageUploader
  has_many :tours, :dependent => :destroy
  has_one :product, :through => :selected_product
  has_one :selected_product,:dependent => :destroy
  has_one :package, :through => :selected_package
  has_one :selected_package,:dependent => :destroy
  has_one :card,:dependent => :destroy
  has_many :feedbacks, :dependent => :destroy
  has_many :paintings, :dependent=>:destroy
  

  def package=(pkg)
    p=Package.find(pkg[:id].to_i)
    if pkg.include?:type_of_payment
      self.selected_package=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>pkg["type_of_payment"])
    else
      self.selected_package=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour)
    end
  end
  def product=(pro)
    unless pro.nil?
      self.selected_product=SelectedProduct.create(:product_id=>pro.to_i)
    end
  end
  def upgrade_package(pkg)
    pkg.merge!(:type_of_payment=>self.selected_package.payment_period_type)
    self.selected_package.destroy

    self.package=pkg
  end
  def ajust_amount(price)
    if self.card.nil?
      price.to_f-unused_money(price)
  
    else
      price
    end

  end
  def packages_for_upgarde
    pkg=self.selected_package.package
    price=pkg.yearly_price
    Package.where("product_id=:product_id AND yearly_price > :price",{:product_id=>pkg.product_id,:price=>price})
    #self.selected_product.product.packages
  end
  private
  def unused_money(price)
    s_pkg=self.selected_package
    (s_pkg.price.to_f/s_pkg.subscribed_days)*(s_pkg.renew_date-Date.today)
  end
end
