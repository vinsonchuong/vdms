class AdmitRanking < Ranking
  def after_initialize
    if self.new_record?
      self.mandatory ||= false
      self.time_slots ||= 1
      self.one_on_one ||= false
    end
  end

  belongs_to :faculty
  belongs_to :admit

  validates_inclusion_of :mandatory, :in => [true, false]
  validates_numericality_of :time_slots, :only_integer => true, :greater_than => 0
  validates_inclusion_of :one_on_one, :in => [true, false]
  validates_existence_of :faculty
  validates_existence_of :admit
  validates_uniqueness_of :admit_id, :scope => :faculty_id
end