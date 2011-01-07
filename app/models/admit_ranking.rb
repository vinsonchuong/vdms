class AdmitRanking < Ranking
  ATTRIBUTES = Ranking::ATTRIBUTES.merge({
    'Mandatory' => :mandatory,
    'Time Slots' => :time_slots,
    'One-On-One' => :one_on_one
  })
  ATTRIBUTE_TYPES = Ranking::ATTRIBUTE_TYPES.merge({
    :mandatory => :boolean,
    :time_slots => :integer,
    :one_on_one => :boolean
  })

  def after_initialize
    if new_record? # work around for bug 3165
      self.mandatory ||= false
      self.time_slots ||= 1
      self.one_on_one ||= false
    end
  end  

  validates_uniqueness_of :rank, :scope => :faculty_id
  validates_inclusion_of :mandatory, :in => [true, false]
  validates_numericality_of :time_slots, :only_integer => true, :greater_than => 0
  validates_inclusion_of :one_on_one, :in => [true, false]
  validates_existence_of :faculty
  validates_existence_of :admit
  validates_uniqueness_of :admit_id, :scope => :faculty_id

  belongs_to :faculty
  belongs_to :admit
end