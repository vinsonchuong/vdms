class AdmitRanking < Ranking
  ATTRIBUTES = Ranking::ATTRIBUTES.merge({
    'Mandatory' => :mandatory,
    'Time Slots' => :time_slots,
    'One-On-One' => :one_on_one
  })

  belongs_to :faculty
  belongs_to :admit
end