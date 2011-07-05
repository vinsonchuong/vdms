class VisitorAvailability < Availability
  attr_accessible :visitor, :visitor_id

  belongs_to :visitor, :class_name => 'Admit'
  has_many :meetings, :dependent => :destroy
  has_many :hosts, :through => :meetings

  default_scope :joins => [:time_slot, :visitor], :order => 'begin, last_name, first_name'

  validates_existence_of :visitor
end