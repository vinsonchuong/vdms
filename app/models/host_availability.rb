class HostAvailability < Availability
  #attr_accessible :host, :host_id, :room

  after_save do |record|
    record.meetings.destroy_all unless record.available?
  end

  belongs_to :schedulable, :class_name => 'Host'
  has_many :meetings, :dependent => :destroy
  has_many :visitors, :through => :meetings
  accepts_nested_attributes_for :meetings, :reject_if => :all_blank, :allow_destroy => true

  default_scope :joins => [:time_slot, {:schedulable => :person}], :order => 'begin, name'

  validates_existence_of :schedulable
end
