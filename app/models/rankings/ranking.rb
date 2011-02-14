class Ranking < ActiveRecord::Base
  validates_numericality_of :rank, :only_integer => true, :greater_than => 0
end
