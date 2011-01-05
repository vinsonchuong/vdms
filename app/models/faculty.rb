class Faculty < Person
  ATTRIBUTES = Person::ATTRIBUTES.merge ({
    'Area' => :area,
    'Division' => :division,
    'Schedule' => :schedule,
    'Default Room' => :default_room,
    'Max Admits Per Meeting' => :max_admits_per_meeting,
    'Max Additional Admits' => :max_additional_admits
  })
  serialize :schedule, Array

  has_many :admit_rankings
  has_many :meetings

=begin
  Draft of helper method to achieve symmetry with Admits (pending RSpec tests)

  def available_times
    schedule.inject {|result, s| result + s[:times]}
  end
=end
end
