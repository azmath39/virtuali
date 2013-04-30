class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  attr_accessible :name, :phno, :email, :password, :password_confirmation, :add1, :add2, :state, :city, :zipcode, :remember_me, :image,:product,:package,:coupon
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
  before_save :set_balance
  after_create :set_auto_destroy_event, :trace_activity
  after_create :add_coupon_transaction, :if=> Proc.new { |user| !user.assigned_coupon.nil?}
  has_many :payments, :dependent=> :destroy
  has_one :coupon, :through=>:assigned_coupon
  has_one :assigned_coupon, :dependent => :destroy
  has_many :coupons, :through=>:coupon_transactions
  has_many :coupon_transactions
  has_one :company, :dependent => :destroy
  has_many :activities
  scope :recent, :limit => 5, :order => 'created_at DESC'
  delegate :coupon_id, :to=>:assigned_coupon, :prefix=>true
  def set_balance
    self.balance ||= 0
  end
  def trace_activity
    activities.create(:activity_type=>0, :charge=>Payments.last.amount)
  end
  def address
    "#{add1} #{add2}\n#{state} #{city}\n\n#{zipcode}"
  end
  def package_name
    self.selected_package.package_name
  end
  def package_price_admin
    "$ #{self.selected_package.price}"
  end
  def product_name
    self.selected_product.product.name
  end
  def product=(pro)
    unless pro.nil?
      self.selected_product=SelectedProduct.create(:product_id=>pro.to_i)
    end
  end
  #  def company=(cmp)
  #    @comp = cmp
  #    self.company= Company.create(@comp)
  #  end
  def package=(pkg)
    assign_package(pkg)
  end
  def coupon=(c)
    self.create_assigned_coupon(:coupon_id=>c[:id],:valid_date=>c[:valid_date])
  end
  def add_coupon_transaction
    self.coupon_transactions<<CouponTransaction.create(:coupon_id=>self.assigned_coupon_coupon_id, :email=>self.email,:name=>self.name)
  end
 
  def  assign_package(pkg)
    p=Package.find(pkg[:id].to_i)
    if pkg.include?:type_of_payment and !p.special_price.nil?
      self.selected_package=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>pkg["type_of_payment"])
    else
      self.selected_package=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>3)
    end
  end
  def subscribe_product
    pkg=self.selected_package.package
    a=[]
    unless pkg.package_type==2
      a<< self.selected_product.product
    else
      a<< Product.where(:category_id=>pkg.product.category_id,:product_type=>1)
      a.flatten!
    end
  end
  def subscribe_product_for_upgrade
    pkg=self.selected_package.package
    a=[]
    unless pkg.package_type==2
      a<< self.selected_product.product
    else
      a<< Product.where(:category_id=>pkg.product.category_id)
      a.flatten!
    end
  end
  def price_after_discount(total)
    total-self.assigned_coupon.coupon.value.to_f
  end
  def package_price
    price = self.selected_package.price
    if any_coupon?
      price_after_discount(price)
    else
      price
    end
  end

  def total_after_all_discounts
    price=selected_package.price
    if any_coupon?
      price=price_after_discount(price)
    end
    if balance< price
      price=price-balance
     
    else
 
      price=0
    end
    
    
  end
  def packages_for_upgarde(package_type)
    #pkg=self.selected_package.package
    #price=pkg.yearly_price
    #Package.where("product_id=:product_id AND yearly_price > :price",{:product_id=>pkg.product_id,:price=>price})

    #self.selected_product.product.packages.where(:package_type=>package_type)
    price = self.package.regular_price
    product.packages.where("regular_price>:price AND package_type=:package_type",:price=>price,:package_type=>package_type) 

  end
  def packages_for_downgrade(package_type)
    price = self.package.regular_price
    product.packages.where("regular_price>10 AND regular_price<:price AND package_type=:package_type",:price=>price,:package_type=>package_type) unless price==10
  end
  def packages_for_downgrade_combo(product_id,package_type)
    product=Product.find(product_id)
    price = self.package.regular_price
    product.packages.where("regular_price>10 AND regular_price<:price AND package_type=:package_type",:price=>price,:package_type=>package_type) unless price==10

  end
  def change_product(pro)
    self.selected_product.update_attributes(:product_id=>pro.to_i)
  end
  def change_package(pkg)
    new_package=Package.find(pkg[:id].to_i)
    previous_package=self.selected_package.package
    if new_package.regular_price >=previous_package.regular_price or self.selected_package.status!=1
      package_upgrade(pkg)
      tours_inactive if  new_package.package_type.to_i==2 and  previous_package.package_type.to_i==1
    else
      destroy_delay_job
      d =Delayed::Job.enqueue Dowgrade.new(self.id,pkg,new_package.no_of_tours,previous_package.no_of_tours),:priority=>0, :run_at=>self.selected_package.remaining_days.day.from_now
      self.user_delay_job=UserDelayJob.create(:delayed_job_id=>d.id)
      #downgrade_package(pkg,@new_package.no_of_tours,@previous_package.no_of_tours)
      msg="You have successfully Dowgraded your package. Your change package will not affect until the current package validity"
      send_message("Important Alert!",msg);
    end
  end
  def package_upgrade(pkg)
    assign_package(pkg)
    self.selected_package.tours_enable
    set_auto_destroy_event
    msg="Your have Successfully upgrade your package. Kindly, Login to your acount and check for any changes you may need."
    send_message("Important Alert!",msg);
  end
  def downgrade_package(pkg,new_no_of_tours,pre_no_of_tours)
    assign_package(pkg)
    if new_no_of_tours==0 or new_no_of_tours==pre_no_of_tours
      tours_inactive
      set_auto_destroy_event
      msg="You have Dowgraded your package. All your tour are been Inactivated. Ajust your tour according to your package and then reset them to active mode."
    else
      tours_disable
      msg="You have Dowgraded your package. All your tour are been Disabled and will be deleted after 10 day from now. Immediatly, ajust your tour according to your package and then reset them to active mode."

      d =Delayed::Job.enqueue TourDestroy.new(self.id),:priority=>0, :run_at=>10.day.from_now
      self.user_delay_job.update_attributes(:delayed_job_id=>d.id)
    end

    send_message("Important Alert!",msg);
  end

  def downgrade(pkg)
    previous_package=selected_package
    new_package= Package.find(pkg[:id])
    if previous_package.remaining_days>15 and previous_package.payment_period_type==1
      refund= (package.regular_price-new_package.regular_price).round
    else
      refund=0
    end

    activities.create(:activity_type=>1, :refund=>refund)
    update_package(new_package)
    self.balance += refund
    self.save
    tours_disable
  end
  def upgrade_charge(id)
    puts "-------------"
    previous_package=selected_package
    new_package= Package.find(id)
    if previous_package.remaining_days>15 and previous_package.payment_period_type==1
      (new_package.regular_price-package.regular_price).round
    elsif  previous_package.payment_period_type==3
      new_package.regular_price
    else
      0
    end
  end 
  def upgrade(pkg)
    new_package= Package.find(pkg[:id])
    update_package(new_package)
    activities.create(:activity_type=>2, :charge=>Payments.last.amount)
  end
  def update_package(pkg)
    selected_package.update_attributes(:package_id=>pkg.id,:price=>pkg.regular_price,:status=>1,:pictures_for_tour=>pkg.pictures_for_tour)

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
    if self.selected_package.status==1
      set_auto_destroy_event
      msg="All your tours are removed from virtuali. Login into your Account and create new tours. "
    else
      d =Delayed::Job.enqueue UserDestroy.new(self.id),:priority=>0, :run_at=>30.day.from_now
      self.user_delay_job.update_attributes(:delayed_job_id=>d.id)
      msg="All your tours are removed from virtuali and Your account will deleted after 30 day from now. Login into your Account and Purchase any package, to keep your account live. "

    end
    send_message("Important Alert!", msg);
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
 def adjust_balance
    self.balance -= (package_price-payments.last.amount)
    self.save
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
    d=Delayed::Job.enqueue RenewAlertMail.new(self.id), :priority=>0, :run_at=>s_pkg.validity
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
    #a= amount.to_i/100
    a=amount.to_f
    payment=Payment.create(:reference=>reference,:amount=>a,:payment_type=>type,:name=>self.name,:email=>self.email,:product_id=>self.selected_product.product_id)
    self.payments<< payment
    send_reciept_user(payment)

  end
 
  def send_reciept_user(payment)
    msg="<table class='table table-bordered'><caption>Your Payment Details</caption><tr><th>Refference No</th><td> #{payment.reference}</td></tr> <tr><th> Date of Transaction</th><td>#{payment.created_at.strftime("%d-%b-%Y %H:%M")}</td></tr><tr><th>Amount</th><td> #{payment.amount}</td></tr> <tr><th> Payment Type</th><td> #{payment.payment_type_info}</td></tr></table>".html_safe
    subject= "Payment Reciept #{payment.created_at.strftime("%d-%b-%Y %H:%M")} "
    send_message(subject, msg)
  end
  def account_valid
    if self.selected_package.nil? or self.selected_package.status>1 or self.selected_package.renew_date < Date.today
      false
    else
      true
    end
  end
  def any_cash_back
    self.selected_package.remaining_days> 213 and self.selected_package.price>=300
  end
 
  def special_offer
    !self.selected_package.nil? and (Date.today-self.selected_package.created_at.to_date).to_i > 183
  end
  def validate_no_of_tours?
    self.tours.count.to_i > 1 and self.selected_package.package.no_of_tours.to_i == 1 
  end
  def any_instructions?
    self.tours.any?{|tour| tour.status==2}
  end
  def check_tours_type?
    pkg= self.selected_package.package
    self.tours.any?{|tour| pkg.package_type!=2 and pkg.product.id!=tour.product_id}
  end
  def check_name_of_pictures?
    paintings.any?{|painting| painting.name.nil?}
  end
  def multiple_products?
    self.subscribe_product.count>1
  end
  def any_coupon?
    !self.assigned_coupon.nil? and self.assigned_coupon.valid_date>Date.today
  end
  def any_package_change?

   if !activities.nil? and  activities.any?{|activity| activity.activity_type!=0}
     (Date.today-activities.where(:activity_type=>(1..2)).last.created_at.to_date).to_i > 30
   else
     true
    end
  end

  #  def change_to_montly_plan(pkg)
  #     p=Package.find(pkg[:id].to_i)
  #     unless p.monthly_price.nil?
  #    self.packag=s_pkg=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>1,:renew_date=>estimate_renew_date(p.montly_price,30))
  #     else
  #      self.packag=s_pkg=SelectedPackage.create(:package_id=>p.id,:pictures_for_tour=>p.pictures_for_tour,:payment_period_type=>2,:renew_date=>estimate_renew_date(p.yearly_price,365))
  ##     end
  #  end
  #note change
  #  def self.appliction_size
  #    require 'find'
  #    size = 0
  #    Find.find(Rails.root) { |f| size += File.size(f) if File.file?(f) }
  #    size/(1024*1024)
  #  end
  def send_message(subject,message)
    #NotificationsMailer.alert_message(self.email,subject, message).deliver
  end
  
  private
  def unused_money(price)
    s_pkg=self.selected_package
    (s_pkg.price.to_f/s_pkg.subscribed_days)*(s_pkg.renew_date-Date.today).to_i
  end
  def estimate_renew_date(price,days)
    return  (Date.today+150*days/price).to_date
  end
end
