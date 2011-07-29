class Ranking < ActiveRecord::Base
  default_scope :order => 'rank'

  validates_numericality_of :rank, :only_integer => true, :greater_than => 0

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Ranking.model_name
      end
    end
    super
  end

  # Naming Ambiguity
  def self.by_rank
    Ranking.all.sort! {|x, y| y.score <=> x.score}
  end
end
