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
  attr_accessible :gmaps, :state, :description, :city, :zip, :subdivision, :price,:address1,:address2, :square_footage, :status,:user_id,:name,:bed_rooms, :bath_rooms,:product_id,:selected_package_id,:status, :acreage, :mls_id, :store_realtor
  #attr_accessor :pro
  acts_as_paranoid
  validates :state, :city, :zip, :price, :address1, :square_footage,:product_id, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0}
  validates :description, :length => {:maximum => 300 }
  after_initialize :set_status

  friendly_id :address, :use=> :slugged
  acts_as_gmappable
  belongs_to :user
  has_many :paintings, :dependent => :destroy
  has_many :messages
  belongs_to :product
  belongs_to :selected_package
  after_create :set_name
   before_create :reset_priority
   def reset_priority
     $serial_no=0;
   end
 before_save :send_tour_to_realtor
#  after_create :set_name, :set_product_id
#  def set_product_id
#    product=self.user.selected_package.package.product_id
#    self.product_id ||= product unless product.nil?
#    self.save
#  end

 delegate :name, :address, :to => :user, :prefix => true
 delegate :name, :to => :product, :prefix => true
 scope :active, where('status = ?' , 1)
 scope :inactive, where(:status =>4)
 scope :disabled, where(:status =>2)
 scope :sold, where('status = ?', 3)


 def self.tours_list_pagination(page)
   order('created_at DESC').paginate(:page => page, :per_page => 24)
 end
 def send_tour_to_realtor
   if self.order_number.blank? && self.store_realtor.present?
     Tour.create_realtor self
   end
   
 end
 def add_line_1
   "#{address1} #{address2}"
 end
 def add_line_2
   "#{city} #{state_code} #{zip}"
 end
 def state_code
   State.find_by_name(state).code
 end
 def set_name
    self.name="#{self.state_code}%#{self.city}%#{self.zip}%#{self.subdivision}"
    self.save
 end
  def gmaps4rails_address
    "#{address1},#{state}, #{city},#{zip}"
  end

  def set_status
    self.status ||= 1
  end
  def address
  "#{self.address1},#{self.city},#{self.state_code},#{self.zip}"
end
def location
  "#{self.address1},#{self.city},#{self.state_code},#{self.zip}"
end
  def tour_name
    "#{self.state_code}%#{self.city}%#{self.zip}%#{self.subdivision}"
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
  def inactive_from
    unless self.status==1
    self.updated_at
    else
      '-'
    end
  end
 
  def validate_picture_count?
    if self.paintings.count.to_i <= self.user.selected_package.pictures_for_tour.to_i
      true
    else
      false
    end
  end
  def display_image
    if !self.paintings.where(:name=>"Front").empty?
    self.paintings.where(:name=>"Front").first.image.url(:small)
    elsif !self.paintings.empty?
       self.paintings.first.image.url(:small)
    else
      '/assets/home_default_image_thumb.jpg'
    end

  end
  def self.create_realtor obj
    state=State.where(:name => obj.state);

    uri = URI('http://picturepath.homestore.com/picturepath/cgi-bin/receiver.pl');
    send_xml =
      "<?xml version='1.0'?>
      <AUI_SUBMISSION VERSION='5.0'>
      <TOUR>
      <CUSTREFNUM></CUSTREFNUM>
      <ORDERNUM></ORDERNUM>
      <PRODUCT_SKU></PRODUCT_SKU>
      <PRODUCT_LINE>LINK</PRODUCT_LINE>
      <ADDRESS>
      <STREET1>obj.address1</STREET1>
      <STREET2/>
      <CITY>#{obj.city}</CITY>
      <STATE>#{state.first.code}</STATE>
      <COUNTRY CODE='US'/>
      <ZIP>#{obj.zip}</ZIP>
      </ADDRESS>
      <IDENTIFIERS>
      <ID1 VALUE='#{obj.mls_id}' TYPE='MLSID'/>
      <ID2 VALUE='' TYPE='MLSID'/>
      </IDENTIFIERS>
      <DISTRIBUTION>
      <SITE>2845</SITE>
      </DISTRIBUTION>
      <TOUR_URL>
      http://www.virtualiinc.com/tours/110-clay-brook-dr-goldsboro-north-carolina-27530--112
      </TOUR_URL>
      </TOUR>
      </AUI_SUBMISSION>"
    params_xml = { :username => "virtuali", :password => "kevislad1", :client => "AUI", :version => 5.0, :action => "Submit", :xml => send_xml}
   uri.query = URI.encode_www_form(params_xml)
   res = Net::HTTP.get_response(uri)
   @doc=Nokogiri::XML(res.body) if res.is_a?(Net::HTTPSuccess)
   logger.info @doc.to_xml
   obj.order_number=(@doc.xpath("//ORDER_NUMBER/text()")).to_s
   logger.info "#{obj.order_number}-------------------------------------------------"
  end
end
