class Ranking < ActiveRecord::Base
  ATTRIBUTES = {
    'Rank' => :rank
  }
  ATTRIBUTE_TYPES = {
    :rank => :integer
  }

  validates_numericality_of :rank, :only_integer => true, :greater_than => 0
end
