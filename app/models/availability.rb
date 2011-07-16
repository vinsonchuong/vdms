class Availability < ActiveRecord::Base
  #attr_accessible :time_slot, :time_slot_id, :available

  belongs_to :time_slot

  default_scope :joins => :time_slot, :order => 'begin'

  validates_existence_of :time_slot
end