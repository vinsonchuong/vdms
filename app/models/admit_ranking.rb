class AdmitRanking < Ranking
  ATTRIBUTES = Ranking::ATTRIBUTES.merge({
    'Mandatory' => :mandatory,
    'Time Slots' => :time_slots,
    'One-On-One' => :one_on_one
  })

  def after_initialize
    if new_record? # work around for bug 3165
      self.mandatory ||= false
      self.time_slots ||= 1
      self.one_on_one ||= false
    end
  end  

  validates_inclusion_of :mandatory, :in => [true, false]
  validates_numericality_of :time_slots, :only_integer => true, :greater_than => 0
  validates_inclusion_of :one_on_one, :in => [true, false]
  validates_existence_of :faculty
  validates_existence_of :admit

  belongs_to :faculty
  belongs_to :admit
end