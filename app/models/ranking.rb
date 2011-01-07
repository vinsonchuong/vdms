=begin
Ranking is an "abstract class" whose purpose is to capture the commonality
between AdmitRanking and FacultyRanking.
=end
class Ranking < ActiveRecord::Base
  ATTRIBUTES = {
    'Rank' => :rank
  }
  ATTRIBUTE_TYPES = {
    :rank => :integer
  }

  validates_numericality_of :rank, :only_integer => true, :greater_than => 0
end
