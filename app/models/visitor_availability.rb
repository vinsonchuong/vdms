class VisitorAvailability < Availability
  #attr_accessible :visitor, :visitor_id

  after_save do |record|
    record.meetings.destroy_all unless record.available?
  end

  belongs_to :schedulable, :class_name => 'Visitor'
  has_many :meetings, :dependent => :destroy
  has_many :hosts, :through => :meetings

  default_scope joins(:time_slot).joins(:schedulable => :person).order('begin, name').readonly(false)

  validates_existence_of :schedulable
end
