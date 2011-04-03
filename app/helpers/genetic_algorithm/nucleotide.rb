module MeetingsScheduler::GeneticAlgorithm

  class Nucleotide
    attr_reader :faculty
    attr_accessor :admit
    attr_reader :schedule_index

    def self.set_fitness_scores_table(fitness_scores_table)
      @@fitness_scores_table = fitness_scores_table
    end

    def initialize(faculty_hash, schedule_index, admit_hash)
      @faculty = faculty_hash
      @schedule_index = schedule_index
      @admit = admit_hash
    end

    def admit_id
      @admit ? @admit[:id] : nil
    end

    def faculty_id
      @faculty[:id]
    end

    def schedule
      @faculty[:schedule][@schedule_index]
    end

    def extract
      [@faculty, schedule, @admit]
    end

    def ==(other)
      @faculty.inspect == other.faculty.inspect and
        @schedule_index == other.schedule_index and
        @admit.inspect == other.admit.inspect
    end

    def fitness
      if @admit
        (not is_meeting_possible?) ? is_meeting_possible_score :
          is_meeting_possible_score +
          faculty_preference_score +
          admit_preference_score +
          area_match_score
      else
        0
      end
    end

    def get_faculty_ranking
      @admit ? @admit[:rankings].find{ |ranking| ranking[:faculty_id] == @faculty[:id] } : nil
    end

    def get_admit_ranking
      @admit ? @faculty[:rankings].find{ |ranking| ranking[:admit_id] == @admit[:id] } : nil
    end

    def is_meeting_possible?
      if @admit
        faculty_timeslot = @faculty[:schedule][@schedule_index][:time_slot]
        @admit[:available_times].contain_set?(RangeSet.new([faculty_timeslot]))
      else
        false
      end
    end

    def mandatory?
      ranking = get_admit_ranking
      (ranking and ranking[:mandatory]) ? true : false
    end

    def one_on_one_meeting_requested?
      ranking = get_admit_ranking
      (ranking and ranking[:one_on_one]) ? true : false
    end

    def num_timeslots_requested
      ranking = get_admit_ranking
      (ranking and ranking[:time_slots]) ? ranking[:time_slots] : 0
    end


    #private unless Rails.env == 'test'

    def is_meeting_possible_score
      is_meeting_possible? ? @@fitness_scores_table[:is_meeting_possible_score] :
        @@fitness_scores_table[:is_meeting_possible_penalty]
    end

    def area_match_score
      [@admit[:area1], @admit[:area2]].include?(@faculty[:area]) ?
      @@fitness_scores_table[:area_match_score] : @@fitness_scores_table[:area_match_default]
    end

    def admit_preference_score
      ranking = get_admit_ranking
      if ranking
        @@fitness_scores_table[:admit_ranking_weight_score] * (@faculty[:rankings].count+1 - ranking[:rank]) +
          mandatory_meeting_score
      else
        @@fitness_scores_table[:admit_ranking_default]
      end
    end

    def faculty_preference_score
      ranking = get_faculty_ranking
      if ranking
        @@fitness_scores_table[:faculty_ranking_weight_score] * (@admit[:rankings].count+1 - ranking[:rank])
      else
        @@fitness_scores_table[:faculty_ranking_default]
      end
    end

    def mandatory_meeting_score
      mandatory? ? @@fitness_scores_table[:mandatory_score] : @@fitness_scores_table[:mandatory_default]
    end
  end

end
