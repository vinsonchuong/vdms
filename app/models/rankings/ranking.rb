class Ranking < ActiveRecord::Base
  validates_numericality_of :rank, :only_integer => true, :greater_than => 0

  def self.by_rank
    Ranking.all.sort! {|x, y| y.score <=> x.score}
  end
end
