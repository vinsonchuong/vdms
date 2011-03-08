class CreateSchedulerFactorsTable < ActiveRecord::Migration
  def self.up
    create_table :scheduler_factors_tables do |t|
      t.integer :settings_id
      t.float :is_meeting_possible_score
      t.float :is_meeting_possible_penalty
      t.float :faculty_ranking_weight_score
      t.float :faculty_ranking_default
      t.float :admit_ranking_weight_score
      t.float :admit_ranking_default
      t.float :area_match_score
      t.float :area_match_default
      t.float :one_on_one_score
      t.float :one_on_one_penalty
      t.float :one_on_one_default
      t.float :mandatory_score
      t.float :mandatory_default
      t.float :consecutive_timeslots_default
      t.float :consecutive_timeslots_weight_score
      t.integer :number_of_spots_per_admit
      t.float :chromosomal_inversion_probability
      t.float :point_mutation_probability
      t.float :double_crossover_probability

      t.timestamps
    end
  end

  def self.down
    drop_table :scheduler_factors_tables
  end
end
