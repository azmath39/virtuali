class Activity < ActiveRecord::Base
  attr_accessible :activity_type, :charge,:refund,:balance, :user_id
  belongs_to :user
  before_create :assign_amount_figures
  after_create :caluclate_balance
  scope :last_butone, :offset=>1,:order => 'created_at DESC'
  def assign_amount_figures
    self.charge ||= 0
    self.refund ||= 0
    self.balance ||=0

  end
  def caluclate_balance
    amt=0
    amt=user.activities.last_butone.first.balance unless user.activities.last_butone.empty?
    #self.balance = amt + refund - charge
    self.balance = amt + refund
    self.save
  end
end
