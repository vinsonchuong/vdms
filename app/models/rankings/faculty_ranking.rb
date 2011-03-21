class FacultyRanking < Ranking
  belongs_to :admit
  belongs_to :faculty

  #validates_existence_of :admit
  #validates_existence_of :faculty
  validates_uniqueness_of :faculty_id, :scope => :admit_id
  validate do |record| # faculty is not nil, used for CSV imports.
    record.errors.add_to_base('Faculty not recognized') if record.faculty.nil?
  end

  def score
    s = Settings.instance
    s.admit_weight.to_f * (s.rank_weight.to_f/self.rank.to_f)
  end
end