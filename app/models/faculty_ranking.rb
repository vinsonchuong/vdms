class FacultyRanking < Ranking
  validates_existence_of :admit
  validates_existence_of :faculty

  belongs_to :admit
  belongs_to :faculty
end