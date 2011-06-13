class HostTimeSlot < TimeSlot
  belongs_to :host, :class_name => 'Faculty'
  has_many :meetings, :dependent => :destroy

  validates_existence_of :host
end