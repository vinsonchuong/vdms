class VisitorRanking < Ranking
  belongs_to :ranker, :class_name => 'Visitor'
  belongs_to :rankable, :class_name => 'Host'

  validates_existence_of :ranker
  validates_existence_of :rankable
  validates_uniqueness_of :rankable_id, :scope => :ranker_id

  # Existence validation sufficient?
  validate do |record| # faculty is not nil, used for CSV imports.
    record.errors.add_to_base('Host not recognized') if record.rankable.nil?
  end

  # Not concern of Ranking
  def score
    s = Settings.instance
    s.admit_weight.to_f * (s.rank_weight.to_f/self.rank.to_f)
  end
end