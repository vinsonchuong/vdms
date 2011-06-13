class Division < ActiveRecord::Base
  include Schedulable

  belongs_to :settings
  has_many :time_slots, :class_name => 'DivisionTimeSlot', :order => 'begin ASC', :dependent => :destroy
  accepts_nested_attributes_for :time_slots, :reject_if => :all_blank, :allow_destroy => true

  validates_presence_of :name
  validates_existence_of :settings

  def long_name
    STATIC_SETTINGS['divisions'][self.name.downcase]
  end
end
