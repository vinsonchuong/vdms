class Goal < Feature
  validates_presence_of :weight
  validates_numericality_of :weight, :greater_than_or_equal_to => 0
end
