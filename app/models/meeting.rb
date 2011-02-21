class Meeting < ActiveRecord::Base
  belongs_to :faculty
  has_and_belongs_to_many :admits

  validates_datetime :time
  validates_presence_of :room
  validates_existence_of :faculty
  
  
  def self.generate
    MeetingsScheduler::GeneticAlgorithm.initialize(self.factors_to_consider, self.fitness_scores_table)
    MeetingsScheduler::GeneticAlgorithm.run(40, 1000)
    
  end
  
  
  private unless Rails.env == "test"
  

  def self.fitness_scores_table
    { # these values need to be fixed
      :is_meeting_possible_score       => rand(100),
      :is_meeting_possible_penalty     => 0,
      :faculty_ranking_weight_score => rand(100),
      :faculty_ranking_default      => rand(100),
      :admit_ranking_weight_score   => rand(100),
      :admit_ranking_default        => rand(100),
      :area_match_score             => rand(100),
      :area_match_default           => rand(100),
      :one_on_one_score             => rand(100),
      :one_on_one_penalty           => 0,
      :one_on_one_default           => rand(100),
      :mandatory_score              => rand(100),
      :mandatory_default            => rand(100)
    }
  end
    
  def self.factors_to_consider
    {
      :attending_admits => self.attending_admits_hash,
      :faculties => self.faculties_hash, 
      :number_of_spots_per_admit => 1,
      :total_number_of_seats => self.total_number_of_seats,
      :chromosomal_inversion_probability => 0.3, 
      :point_mutation_probability => 0.2,
      :double_crossover_probability =>  0.1
    }
  end
  
  def self.total_number_of_seats
    Faculty.attending_faculties.collect{ |faculty| 
      faculty.available_times.select { |available_time| available_time.available? }.count * 
      faculty.max_admits_per_meeting }.inject(:+)
  end
  
  def self.faculties_hash
    Faculty.attending_faculties.inject({}) do |faculties_hash, faculty| 
      faculties_hash.merge(
        { faculty.id => 
          { :id => faculty.id,
            :area => faculty.area,
            :max_students_per_meeting => faculty.max_admits_per_meeting,
            :rankings => faculty.admit_rankings.collect do |admit_ranking| 
              { 
                :rank => admit_ranking.rank, 
                :faculty_id => admit_ranking.faculty_id,
                :admit_id => admit_ranking.admit_id,
                :mandatory => admit_ranking.mandatory,
                :one_on_one => admit_ranking.one_on_one,
                :time_slots => admit_ranking.time_slots 
              }
            end,
            :schedule => faculty.available_times.all.select{ |available_time| available_time.available? }.collect do |available_time|
              { 
                :room => available_time.room,
                :time_slot => available_time.begin..available_time.end
              }
            end
          }
        }
      )
    end
  end
  
  def self.attending_admits_hash
    Admit.all.inject({}) do |attending_admits_hash, admit|
      attending_admits_hash.merge(
        { admit.id =>
          { :id => admit.id,
            :name => admit.full_name,
            :area1 => admit.area1,
            :area2 => admit.area2,                    
            :rankings => admit.faculty_rankings.collect do |faculty_ranking|
              {
                :rank => faculty_ranking.rank, 
                :faculty_id => faculty_ranking.faculty_id,
                :admit_id => faculty_ranking.admit_id,
                :mandatory => faculty_ranking.mandatory,
                :one_on_one => faculty_ranking.one_on_one,
                :time_slots => faculty_ranking.time_slots
              }
            end,
            :available_times => RangeSet.new(admit.available_times.collect{ |available_time| available_time.begin..available_time.end })
          }        
        }
      )
    end
  end
  
end
