=begin
Ranking is an "abstract class" whose purpose is to capture the commonality
between AdmitRanking and FacultyRanking.
=end
class Ranking < ActiveRecord::Base
  ATTRIBUTES = {
    'Rank' => :rank
  }
end
