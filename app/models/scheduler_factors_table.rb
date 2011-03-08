class SchedulerFactorsTable < ActiveRecord::Base
  include Schedulable

  belongs_to :settings

  validates_presence_of :is_meeting_possible_score,
                        :is_meeting_possible_penalty,
                        :faculty_ranking_weight_score,
                        :faculty_ranking_default,
                        :admit_ranking_weight_score,
                        :admit_ranking_default,
                        :area_match_score,
                        :area_match_default,
                        :one_on_one_score,
                        :one_on_one_penalty,
                        :one_on_one_default,
                        :mandatory_score,
                        :mandatory_default,
                        :consecutive_timeslots_default,
                        :consecutive_timeslots_weight_score,
                        :number_of_spots_per_admit,
                        :chromosomal_inversion_probability,
                        :point_mutation_probability,
                        :double_crossover_probability

  [:chromosomal_inversion_probability,
   :point_mutation_probability,
   :double_crossover_probability].each{ |var| validates_inclusion_of var, :within => 0...1 }
  validates_inclusion_of :number_of_spots_per_admit, :within => 1..5

  def fitness_scores_table
    {
      :is_meeting_possible_score => is_meeting_possible_score,
      :is_meeting_possible_penalty => is_meeting_possible_penalty,
      :faculty_ranking_weight_score => faculty_ranking_weight_score,
      :faculty_ranking_default => faculty_ranking_default,
      :admit_ranking_weight_score => admit_ranking_weight_score,
      :admit_ranking_default => admit_ranking_default,
      :area_match_score => area_match_score,
      :area_match_default => area_match_default,
      :one_on_one_score => one_on_one_score,
      :one_on_one_penalty => one_on_one_penalty,
      :one_on_one_default => one_on_one_default,
      :mandatory_score => mandatory_score,
      :mandatory_default => mandatory_default,
      :consecutive_timeslots_default => consecutive_timeslots_default,
      :consecutive_timeslots_weight_score => consecutive_timeslots_weight_score
    }
  end

  def other_factors
    {
      :number_of_spots_per_admit => number_of_spots_per_admit,
      :chromosomal_inversion_probability => chromosomal_inversion_probability,
      :point_mutation_probability => point_mutation_probability,
      :double_crossover_probability => double_crossover_probability
    }
  end
end
