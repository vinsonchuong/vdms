class VisitorAvailability < Availability
  #attr_accessible :visitor, :visitor_id

  after_save do |record|
    record.meetings.destroy_all unless record.available?
  end

  belongs_to :visitor, :foreign_key => :schedulable_id
  has_many :meetings, :dependent => :destroy
  has_many :hosts, :through => :meetings

  default_scope :joins => [:time_slot, {:visitor => :person}], :order => 'begin, name'

  validates_existence_of :visitor
end