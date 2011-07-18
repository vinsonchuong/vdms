class Ranking < ActiveRecord::Base
  default_scope :order => 'rank'

  validates_numericality_of :rank, :only_integer => true, :greater_than => 0

  # Naming Ambiguity
  def self.by_rank
    Ranking.all.sort! {|x, y| y.score <=> x.score}
  end
end
