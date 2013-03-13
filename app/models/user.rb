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
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  attr_accessible :name, :phno, :email, :password, :password_confirmation, :add1, :add2, :state, :city, :zipcode, :remember_me, :image,:product,:package


  mount_uploader :image, ImageUploader
  has_many :tours, :dependent => :destroy
  has_one :product, :through => :selected_product
  has_one :selected_product,:dependent => :destroy
  has_one :package, :through => :selected_package
  has_one :selected_package,:dependent => :destroy
  has_one :card,:dependent => :destroy
  has_many :feedbacks, :dependent => :destroy
  has_many :paintings, :dependent=>:destroy
  has_one :delayed_job, :through=>:user_delay_job, :dependent=>:destroy
  has_one :user_delay_job,  :dependent=>:destroy
  after_create :set_auto_destroy_event
  has_many :payments, :dependent=> :destroy

  def product=(pro)
    unless pro.nil?
      self.selected_product=SelectedProduct.create(:product_id=>pro.to_i)
    end
  end
  def package=(pkg)
    assign_package(pkg)
  end
  def  assign_package(pkg)
    p=Package.find(pkg[:id].to_i)
    if pkg.include?:type_of_payment and !p.special_price.nil?
      self.selected_package=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>pkg["type_of_payment"])
    else
      self.selected_package=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>3)
    end
  end

  def packages_for_upgarde
    #pkg=self.selected_package.package
    #price=pkg.yearly_price
    #Package.where("product_id=:product_id AND yearly_price > :price",{:product_id=>pkg.product_id,:price=>price})
    self.selected_product.product.packages
  end
  
  def change_package(pkg)
    new_package=Package.find(pkg[:id].to_i)
    previous_package=self.selected_package.package
    if new_package.regular_price >=previous_package.regular_price
      package_upgrade(pkg)
    else
      destroy_delay_job
      d =Delayed::Job.enqueue Dowgrade.new(self.id,pkg,new_package.no_of_tours,previous_package.no_of_tours),:priority=>0, :run_at=>self.selected_package.remaining_days.day.from_now
      self.user_delay_job=UserDelayJob.create(:delayed_job_id=>d.id)
      #downgrade_package(pkg,@new_package.no_of_tours,@previous_package.no_of_tours)
    end
  end
  def package_upgrade(pkg)
    assign_package(pkg)
    self.selected_package.tours_enable
    set_auto_destroy_event
  end
  def downgrade_package(pkg,new_no_of_tours,pre_no_of_tours)
    assign_package(pkg)
    if new_no_of_tours==0 or new_no_of_tours==pre_no_of_tours
      tours_inactive
      set_auto_destroy_event
    else
      tours_disable
      
      d =Delayed::Job.enqueue TourDestroy.new(self.id),:priority=>0, :run_at=>10.day.from_now
      self.user_delay_job.update_attributes(:delayed_job_id=>d.id)
    end
  end
  def tours_inactive
    tours=self.tours
    unless tours.empty?
      tours.each do |tour|
        tour.update_attributes(:status=>4)
      end
    end
  end
  def tours_disable
    tours=self.tours
    unless tours.empty?
      tours.each do |tour|
        tour.update_attributes(:status=>2)
      end
      
    end
  end
  def tours_destroy
    tours=self.tours
    unless tours.empty?
      tours.each do |tour|
        tour.destroy
      end
    end
    unless self.selected_package.status==1
      set_auto_destroy_event
    else
      self.selected_package.destroy
      d =Delayed::Job.enqueue UserDestroy.new(self.id),:priority=>0, :run_at=>30.day.from_now
      self.user_delay_job.update_attributes(:delayed_job_id=>d.id)

    end
  end
  def enable_tour
    s_pkg=self.selected_package
    s_pkg.update_attributes(:status=>1) unless s_pkg.status == 1
    tours=self.tours.where('status!=:status',:status=>1)
      unless tours.empty?
        tours.each do |tour|
          tour.update_attributes(:status=>1)
        end

        self.user.set_auto_destroy_event
      end
  end
     
  def cancel_annual_plan
    s_pkg=self.selected_package
    s_pkg.update_attributes(:renew_date=>estimate_renew_date(s_pkg.price,365),:payment_period_type=>1,:price=>s_pkg.package.monthly_price)
    set_auto_destroy_event
  end
  def ajust_amount(price)
    if self.card.nil? and self.account_valid
      price.to_f-unused_money(price)
    else
      price
    end
  end

  def package_destroy
    self.selected_package.package_destroy
#    pkg=self.selected_package
#    unless pkg.nil?
#      pkg.tours_destroy
#      pkg.destroy
#    end
  end
  def set_auto_destroy_event
    destroy_delay_job
    s_pkg=self.selected_package
    d=Delayed::Job.enqueue PackageDisable.new(s_pkg.id), :priority=>0, :run_at=>s_pkg.validity
    self.user_delay_job=UserDelayJob.create(:delayed_job_id=>d.id)
  end
  def destroy_delay_job
    unless self.user_delay_job.nil? then
      dl_job=self.user_delay_job.delayed_job
      dl_job.destroy unless dl_job.nil?
      self.user_delay_job.destroy
    end
  end
  def save_payment_details(reference,type,amount)
   
    a= amount.to_i/100
    self.payments<< Payment.create(:reference=>reference,:amount=>a,:payment_type=>type)

  end
  def account_valid
    if self.selected_package.nil? or self.selected_package.status>1 or self.selected_package.renew_date < Date.today
      false
    else
      true
    end
  end
  def any_cash_back
    if self.selected_package.remaining_days> 213 and self.selected_package.price>=300
      return true
    else
      return false
    end
  end
 
  def special_offer
    if !self.selected_package.nil? and (Date.today-self.selected_package.created_at.to_date).to_i > 183 
      return true
    else
      return false
    end
  end
  def validate_no_of_tours?
    if self.tours.count.to_i > 1 and self.selected_package.package.no_of_tours.to_i == 1
      true
    else
     false
    end
  end
  def any_instructions?
    puts "dfgjdhgjdfgjdfghfdghfkdhgkdfhgkdfhgkdfhgkhdfkghdf"
    self.tours.any?{|tour| tour.status!=1}
  end
  #  def change_to_montly_plan(pkg)
  #     p=Package.find(pkg[:id].to_i)
  #     unless p.monthly_price.nil?
  #    self.packag=s_pkg=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>1,:renew_date=>estimate_renew_date(p.montly_price,30))
  #     else
  #      self.packag=s_pkg=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>2,:renew_date=>estimate_renew_date(p.yearly_price,365))
  #     end
  #  end
  private
  def unused_money(price)
    s_pkg=self.selected_package
    (s_pkg.price.to_f/s_pkg.subscribed_days)*(s_pkg.renew_date-Date.today).to_i
  end
  def estimate_renew_date(price,days)
    return  (Date.today+150*days/price).to_date
  end
end
