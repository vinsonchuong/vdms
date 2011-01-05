class Admit < Person
  ATTRIBUTES = Person::ATTRIBUTES.merge ({
    'Phone' => :phone,
    'Area 1' => :area1,
    'Area 2' => :area2,
    'Attending' => :attending,
    'Available Times' => :available_times
  })
  serialize :available_times, RangeSet

  belongs_to :peer_advisor
  has_many :faculty_rankings
  has_and_belongs_to_many :meetings
end
