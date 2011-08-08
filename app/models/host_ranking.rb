class HostRanking < Ranking
  belongs_to :ranker, :class_name => 'Host'
  belongs_to :rankable, :class_name => 'Visitor'

  validates_existence_of :ranker
  validates_existence_of :rankable
  validates_uniqueness_of :rankable_id, :scope => :ranker_id
  validates_inclusion_of :mandatory, :in => [true, false]
  validates_inclusion_of :one_on_one, :in => [true, false]
  validates_numericality_of :num_time_slots, :only_integer => true, :greater_than => 0

  # Not Concern of Ranking
  def score
    s = Settings.instance
    s.faculty_weight.to_f * (s.rank_weight.to_f/self.rank.to_f + s.mandatory_weight.to_f*(self.mandatory ? 1.0 : 0.0))
  end
end