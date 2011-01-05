class FacultyRanking < Ranking
  ATTRIBUTES = Ranking::ATTRIBUTES.merge({})

  belongs_to :admit
  belongs_to :faculty
end