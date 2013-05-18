class Draft < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :paintings
  belongs_to :user
  before_create :set_name
  private
  def set_name
    self.name ||= DateTime.now.to_s
  end
end
