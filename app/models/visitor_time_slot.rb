class VisitorTimeSlot < TimeSlot
  belongs_to :visitor, :class_name => 'Admit'
  has_many :meetings, :dependent => :destroy

  validates_existence_of :visitor
end