class Admit < Person
=begin
  Attributes
    phone
    area1
    area2
    attending
    available_times
=end
  serialize :available_times, RangeSet

  belongs_to :peer_advisor
  has_many :faculty_rankings
  has_and_belongs_to_many :meetings
end
