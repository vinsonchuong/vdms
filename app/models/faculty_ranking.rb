class FacultyRanking < Ranking
  validates_uniqueness_of :rank, :scope => :admit_id
  validates_existence_of :admit
  validates_existence_of :faculty
  validates_uniqueness_of :faculty_id, :scope => :admit_id

  belongs_to :admit
  belongs_to :faculty
end