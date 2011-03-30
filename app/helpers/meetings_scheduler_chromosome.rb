module MeetingsScheduler
  module GeneticAlgorithm

    class Chromosome
      include Comparable

      attr_accessor :meeting_solution
      attr_accessor :normalized_fitness
      @@factors_to_consider = nil
      @@fitness_scores_table = nil

      def initialize(solution_string)
        @meeting_solution = []
        @normalized_fitness = 0

        @@factors_to_consider[:faculties].each do |faculty_id, faculty|
          faculty[:schedule].each_with_index do |room_timeslot_pair, schedule_index|
            faculty[:max_students_per_meeting].times do
              admit_id = solution_string.slice!(0)
              admit = @@factors_to_consider[:attending_admits][admit_id]
              @meeting_solution << Nucleotide.new(faculty, schedule_index, admit)
            end
          end
        end
      end

      def self.set_factors_to_consider(factors_to_consider)
        @@factors_to_consider = factors_to_consider
      end

      def self.set_fitness_scores_table(fitness_scores)
        @@fitness_scores_table = fitness_scores
        Nucleotide.set_fitness_scores_table(fitness_scores)
      end

      def self.seed
        Chromosome.new(Chromosome.create_solution_string)
      end

      def solution_string
        @meeting_solution.collect{ |nucleotide| nucleotide.admit_id }
      end

      def [](index)
        self.solution_string[index]
      end

      def []=(index, new_nucleotide)
        @meeting_solution[index] =  new_nucleotide
      end

      def <=>(other)
        self.fitness <=> other.fitness
      end

      def length
        @meeting_solution.length
      end

      # Definition: A utility/heuristic value function that evaluates how good a particular solution is
      # @params: NA
      # @return: a fitness value as a Float
      def fitness
        return @fitness if @fitness

        # NO NEED to check if nucleotide contains nil admit because nucleotide.fitness checks for it
        @fitness = reduced_meeting_solution.inject(0){ |fitness, nucleotide| fitness += nucleotide.fitness } +
          chromosome_level_fitness
      end

      def reduced_meeting_solution
        # CURRENTLY DOES NOT HAVE ALL FEATURES YET !!!
        @reduced_meeting_solution = Chromosome.new(solution_string).
            duplicates_per_single_meeting_removed!.
            conflicting_meetings_per_admit_resolved!.meeting_solution
      end

      ###########################################
      # REDUCED MEETING SOLUTION PUBLIC HELPERS #
      ###########################################
      # METHOD IS USED ON CHROMOSOME COPIES ONLY, NOT THE ORIGINAL CHROMOSOME

      # FOR THE CASE IN WHICH AN ADMIT IS SCHEDULED TO MEET WITH THE *SAME FACULTY* AT THE *SAME TIME* MORE THAN ONCE
      def duplicates_per_single_meeting_removed!
        @meeting_solution.each_with_index do |nucleotide, index|
          if duplicates_in_single_meeting?(nucleotide)
            @meeting_solution[index].admit = nil
          end
        end
        self
      end

      # FOR THE CASE IN WHICH AN ADMIT IS SCHEDULED TO MEET WITH TWO FACULTIES AT THE SAME TIME
      def conflicting_meetings_per_admit_resolved!
        @meeting_solution.each do |nucleotide|
          if (conflicting_nucleotides = conflicts_with_other_meetings(nucleotide))
            resolve_conflicting_meetings!(conflicting_nucleotides)
          end
        end
        self
      end

      # Definition: Decides with probabilities defined in factors_to_consider HOW to mutate a chromosome, and calls the appropriate mutation method
      # @params:
      # => a chromosome
      # @return:
      # => a new Chromosome object with the appropriate mutation if it is unfit
      # => the old chromosome if it has good fitness value
      def self.mutate(chromosome)
        if chromosome.ok_to_mutate?
          which_mutation = rand
          case which_mutation
          when 0...@@factors_to_consider[:chromosomal_inversion_probability]
            index1, index2 = chromosome.pick_two_random_indexes
            Chromosome.chromosomal_inversion(chromosome, index1, index2)
          when @@factors_to_consider[:chromosomal_inversion_probability]...
              (@@factors_to_consider[:chromosomal_inversion_probability] + @@factors_to_consider[:point_mutation_probability])
            index = rand(chromosome.length)
            Chromosome.point_mutation(chromosome, index)
          else
            index = rand(chromosome.length-1)
            Chromosome.reverse_two_adjacent_sequences(chromosome, index)
          end
        else
          chromosome
        end
      end

      # Definition: Decides with probabilities defined in factors_to_consider HOW to reproduce,
      #             and calls the appropriate reproduction method
      # @params: Two parent chromosomes
      # @return: only ONE new Chromosome object with the appropriate reproduction operation performed
      def self.reproduce(parent1, parent2)
        if rand < @@factors_to_consider[:double_crossover_probability]
          splice_index1, splice_index2 = parent1.pick_two_random_indexes
          Chromosome.double_crossover(parent1, parent2, splice_index1, splice_index2)
        else
          splice_index = rand(parent1.length - 2)+1
          Chromosome.single_crossover(parent1, parent2, splice_index)
        end
      end

      # Definition: Determines whether a chromosome is 'unfit enough' for a mutation
      # @params:
      # => a Chromosome
      # @return:
      # => true or false
      def ok_to_mutate?
        #chromosome.normalized_fitness && rand < ((1 - chromosome.normalized_fitness) * 0.3)
        true
      end

      #########################
      # MISCELLANEOUS METHODS #
      #########################

      def pick_two_random_indexes
        index1 = index2 = rand(@meeting_solution.length - 5) + 1
        while index2 <= index1+1
          index2 = rand(@meeting_solution.length - 2) + 1
        end
        [index1, index2]
      end



      private unless Rails.env == 'test'

      # Definition: Helper method to create a nucleotide sequence
      # @params: NA
      # @return: a shuffled array of admit_id's
      def self.create_solution_string
        attending_admits = @@factors_to_consider[:attending_admits]
        total_number_of_seats = @@factors_to_consider[:total_number_of_seats]
        number_of_spots_per_admit = @@factors_to_consider[:number_of_spots_per_admit]

        solution_string = Array.new(total_number_of_seats)
        admit_ids = (attending_admits.keys * number_of_spots_per_admit)

        if admit_ids.length < total_number_of_seats
          remaining_empty_seats = total_number_of_seats - admit_ids.length
          admit_ids += remaining_empty_seats.times.collect{ admit_ids.sample }
        end

        solution_string[0...solution_string.length] = admit_ids.shuffle.shuffle[0...solution_string.length] if total_number_of_seats > 0
        solution_string
      end


      ###########################################
      # Reduced Meeting Solution Helper Methods #
      ###########################################
      # ALL METHODS HERE ARE PROTECTED FROM NIL ADMIT CORNER CASES!!!

      def duplicates_in_single_meeting?(nucleotide)
        return false if nucleotide.admit.nil?
        # CANNOT CALL find_all_nucleotides_for_one_timeslot_and_faculty,
        # because code is in meeting_solution space, NOT reduced_meeting_solution space
        nucleotides = @meeting_solution.find_all{ |n| n.faculty_id == nucleotide.faculty_id and n.schedule_index == nucleotide.schedule_index }
        duplicate_ids = nucleotides.collect{ |n| n.admit_id }.inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
        duplicate_ids.include? nucleotide.admit_id
      end

      def conflicts_with_other_meetings(nucleotide)
        return nil if nucleotide.admit.nil?
        conflicting_nucleotides = @meeting_solution.find_all do |n|
          n.admit_id == nucleotide.admit_id and
              n.schedule[:time_slot].begin == nucleotide.schedule[:time_slot].begin
        end
        conflicting_nucleotides.count > 1 ? conflicting_nucleotides : nil
      end

      def resolve_conflicting_meetings!(conflicting_nucleotides)
        best_nucleotide = conflicting_nucleotides.max_by{ |n| n.fitness }
        conflicting_nucleotides.each{ |n| n.admit = nil if n != best_nucleotide }
      end


      #####################################
      # Chromosome Fitness Helper Methods #
      #####################################
      # ALL METHODS HERE ARE PROTECTED FROM NIL ADMIT CORNER CASES!!!

      def chromosome_level_fitness
        @reduced_meeting_solution.inject(0) do |chrom_level_fitness, nucleotide|
          chrom_level_fitness += one_on_one_score(nucleotide) +
            consecutive_timeslots_score(nucleotide)
        end
      end

      def one_on_one_score(nucleotide)
        if nucleotide.one_on_one_meeting_requested?
          is_one_on_one_meeting?(nucleotide) ? @@fitness_scores_table[:one_on_one_score] : @@fitness_scores_table[:one_on_one_penalty]
        else
          @@fitness_scores_table[:one_on_one_default]
        end
      end

      def is_one_on_one_meeting?(nucleotide)
        people_in_this_meeting = find_all_nucleotides_for_one_timeslot_and_faculty(nucleotide)
        people_in_this_meeting.collect{ |n| n.admit_id }.uniq.delete_if{ |id| id == nil } == [nucleotide.admit_id]
      end

      def find_all_nucleotides_for_one_timeslot_and_faculty(nucleotide)
        @reduced_meeting_solution.find_all{ |n| n.faculty_id == nucleotide.faculty_id and n.schedule_index == nucleotide.schedule_index }
      end

      def find_all_nucleotides_for_one_admit_and_faculty(nucleotide)
        @reduced_meeting_solution.find_all{ |n| n.faculty_id == nucleotide.faculty_id and n.admit_id == nucleotide.admit_id }
      end

      def consecutive_timeslots_score(nucleotide)
        if nucleotide.num_timeslots_requested > 1
          meetings = find_all_nucleotides_for_one_admit_and_faculty(nucleotide)
          calculate_consecutive_timeslots_score(meetings)
        else
          @@fitness_scores_table[:consecutive_timeslots_default]
        end
      end

      def calculate_consecutive_timeslots_score(meetings)
        # Codepath guarantees at least ONE nucleotide in meetings before this method is run
        consecutive_timeslots = meetings.length.times.collect[1..-1].reverse.collect do |sublength|
          count_consecutive_timeslots( meetings.last(sublength), meetings.last(sublength)[0].schedule_index )
        end
        consecutive_timeslots.empty? ? 0 :
            consecutive_timeslots.max * @@fitness_scores_table[:consecutive_timeslots_weight_score]
      end

      def count_consecutive_timeslots(meetings, schedule_index)
        if meetings.empty?
          0
        else
          schedule_index == meetings[0].schedule_index ?
          1 + count_consecutive_timeslots(meetings[1..-1], schedule_index+1) : 0
        end
      end


      ###########################
      # Mutation Helper Methods #
      ###########################

      # Definition: Performs a reversal on two adjacent sequences of a Chromosome
      # @params:
      # => a Chromosome
      # @return:
      # => a new Chromosome
      def self.reverse_two_adjacent_sequences(chromosome, index)
        chromosome.length == 1 ? chromosome : Chromosome.chromosomal_inversion(chromosome, index, index+1)
      end

      # Definition: Performs an inversion on a stretch of sequences along a Chromosome
      # @params:
      # => a Chromosome
      # @return:
      # => a new Chromosome
      def self.chromosomal_inversion(chromosome, index1, index2)
        partially_inverted_solution_string = chromosome[index1..index2].reverse
        new_solution_string = chromosome[0...index1] + partially_inverted_solution_string + chromosome[index2+1..-1]
        Chromosome.new(new_solution_string)
      end

      # Definition: Performs a point mutation on one sequence in a Chromosome,
      # by either changing it to an admit_id or nil
      # @params:
      # => a Chromosome
      # @return:
      # => a new Chromosome
      def self.point_mutation(chromosome, index)
        mutated_solution_string = chromosome.solution_string
        admit_id = @@factors_to_consider[:attending_admits].keys.shuffle.shuffle.fetch(0)
        mutated_solution_string[index] = (rand < 0.5) ? admit_id : nil
        Chromosome.new(mutated_solution_string)
      end


      ###############################
      # Reproduction Helper Methods #
      ###############################

      # Definition: Performs a single crossover
      # @params:
      # => 2 parent Chromosomes and a splice index (int)
      # @return:
      # => a new Chromosome
      def self.single_crossover(parent1, parent2, splice_index)
        Chromosome.new(parent1[0...splice_index] + parent2[splice_index..-1])
      end

      # Definition: Performs a double crossover
      # @params:
      # => 2 parent Chromosomes and two splice indexes (int)
      # @return:
      # => a new Chromosome
      def self.double_crossover(parent1, parent2, splice_index1, splice_index2)
        Chromosome.new(parent1[0...splice_index1] + parent2[splice_index1...splice_index2] + parent1[splice_index2..-1])
      end
    end

  end
end