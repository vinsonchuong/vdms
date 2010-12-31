class AdmitRanking < Ranking
=begin
  Attributes 
    mandatory
    time_slots
    one_on_one
=end

  belongs_to :faculty
  belongs_to :admit
end