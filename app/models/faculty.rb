class Faculty < Person
=begin
  Attributes
    area
    division
    schedule
    default_room
    max_students_per_meeting
    max_additional_students
=end
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
