class SpaceUsage < ActiveRecord::Base
  attr_accessible :size
  def self.remaining_space
    unless SpaceUsage.last.nil?
    "#{SpaceUsage::appliction_size}/#{SpaceUsage.last.size} MB"
    else
     "#{SpaceUsage::appliction_size} MB"
    end
  end
  def self.appliction_size
    require 'find'
    size = 0
    Find.find(Rails.root) { |f| size += File.size(f) if File.file?(f) }
    size/(1024*1024)
  end
end
