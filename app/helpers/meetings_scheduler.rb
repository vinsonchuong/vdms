module MeetingsScheduler
  
  class Scheduler
      attr_accessor :population
      attr_accessor :population_size
      attr_accessor :total_generations
    
#Definition: initialize a new Scheduler object
# @params:

#factors_to_consider: a hash that contains all the necessary information to compute optimum meeting arrangement.
#                    The structure of factors_to_consider looks like:
#                    {:attending_admits => a hash of admits attending Visit Day, 
#                     :faculties => a hash of faculties holding meetings, 
#                     :number_of_spots_per_admit => an int, 
#                     :chromosomal_inversion_probability => a decimal range from 0 to 1, 
#                     :point_mutation_probability => a decimal range from 0 to 1,
#                     :double_crossover_probability => a decimal range from 0 to 1,
#                     :lowest_rank_possible => an integer representing the number of ranks an admit can have
#                    }
#                    The structure of :attending_admits looks like:
#                    { id1 => { :id => integer of the admit's database id, same as id1,
#                               :name => a string of the admit's name,
#                               :ranking => array of hashes of the admit's preference list,
#                               :available_times => range_set that encodes the admit's 24 hour availability
#                             },
#                      id2 => { :id => integer of the admit's database id, same as id2,
#                               :name => a string of the admit's name,
#                               :ranking => array of hashes of the admit's preference list,
#                               :available_times => range_set that encodes the admit's 24 hour availability
#                             },
#                    .
#                    .
#                     etc, where id1 and id2 are ints of the admit's database id,              
#                    }
#                    The structure of :faculties looks like:
#                    { fid1 => { :id => integer of the faculty's database id, same as fid1,
#                                :max_students_per_meeting => an int specifying the maximum number of student allowed per meeting for this faculty,
#                                :admit_rankings => array of hashes of the faculty's preference list,
#                                :schedule => [{ :room => 'room1', :time_slot => timerange },
#                                              { :room => 'room2', :time_slot => timerange } ....etc],
#                              },
#                     :fid2 => { :id => integer of the faculty's database id, same as fid2,
#                                :max_students_per_meeting => an int specifying the maximum number of student allowed per meeting for this faculty,
#                                :admit_rankings => array of hashes of the faculty's preference list,
#                                :schedule => [{ :room => 'room1', :time_slot => timerange },
#                                              { :room => 'room2', :time_slot => timerange } ....etc],
#                              },
#                    .
#                    .
#                     etc, where fid1 and fid2 are ints of the faculty's database id
#                    }
#                    note: this hash could still grow as the algorithm demands more information. The API should be updated as this hash changes
#
#population_size: an int specifying the population size of the GA algorithm
#
#total_generation: an int specifying the number of generation the GA algorithm will run/iterate   
#
# @return: new Scheduler object
 
      def initialize(factors_to_consider, population_size, total_generations)        
        @population = Scheduler.create_population(@factors_to_consider)
        @total_generations = total_generations
        @population_size = population_size
      end


# Definition: produces optimum meeting arrangement
# @params: NA
# @return: a list of meeting objects
      
      def make_meetings()
        best_chromosome = GeneticAlgorithm.run(@population, @total_generations)
        Scheduler.create_meetings(best_chromosome)
      end
      
      private unless Rails.env == 'test'
      
# Definition: convert a chromosome to a list of meeting
# @params: a chromosome
# @return: a list of meeting object

      def self.create_meetings(best_chromosome)
        meetings = []
        best_chromosome.meeting_solution.each do |nucleotide|
          if nucleotide.admit_id
            admit = @factors_to_consider[:attending_admits][nucleotide.admit_id]
            faculty = @factors_to_consider[:faculties][nucleotide.faculty_id]
            schedule = faculty[:schedule][nucleotide.schedule_index]
            
            m = meetings[-1]
            if Scheduler.need_a_new_meeting?(m, faculty, schedule)
              m = Scheduler.set_up_new_meeting(faculty, schedule)
            end
            
            # add admits, not sure if this is the proper way to do it
            Admit.find(admit[:id]).meetings << m
            
          end
        end
        
        return meetings
      end
      
# Definition: checks if there needs to be a new Meeting object to be instantiated
# @params: the most recently-made meeting, faculty and schedule subhashes inside factors_to_consider hash
# @return: true or false

      def self.need_a_new_meeting?(current_meeting, faculty, schedule)
        if current_meeting
          current_meeting.faculty_id != faculty[:id] or current_meeting.time != schedule[:time_range].begin
        end
      end

# Definition: sets up a new Meeting object
# @params: the faculty and schedule hashes, subhashes inside factors_to_consider hash
# @return: meeting, a new Meeting object, without any admits attached
      
      def self.set_up_new_meeting(faculty, schedule)
        meeting = Meeting.new
        meeting.faculty_id = faculty[:id]
        # or use Faculty.find(faculty[:id]).meetings.new
        meeting.room = schedule[:room]
        meeting.time = schedule[:time_range].begin
        return meeting
      end
      
# Definition: create a population of chromosomes so the GA algorithm can work with
# @params: the hash factors_to_consider, which is inputed during initialization of the Scheduler object
# @return: population, an array of chromosomes 
      
      def self.create_population(factors_to_consider)
        population = []
        Chromosome.set_factors_to_consider(factors_to_consider)
        @population_size.times do
          population << Chromosome.seed()
        end
        population
      end
               
  end
  
  
  class GeneticAlgorithm
    
# Definition: run is the main execution of the algorithm. Calling run will theoritically output the best solution available after total_generations 
#
# @params: 
# population: an array of chromosomes  
# total_generation: an int to specify how many generation to run the algorithm
# factors_to_consider: a hash, the specific structure of this hash, please refer to Scheduler.new method
# @returns: the best chromosome object
#
    def self.run(population, total_generations, factors_to_consider)
      total_generations.times do
        parents = GeneticAlgorithm.selection(population)
        offsprings = GeneticAlgorithm.reproduction(parents)
        population = GeneticAlgorithm.mutate_all_population(population, factors_to_consider)
        population = GeneticAlgorithm.replace_worst_ranked(population, offsprings)    
      end
      best_chromosome = GeneticAlgorithm.select_best_chromosome(population)
    end

# Definition:      
# selection mimic the process of natural selection to select the individuals that have better fitness values.
# process:
# 1. fitness is called to evaluate the utility value of individual
# 2. the population is sorted by descending order of fitness value
# 3. the fitness value is normalized
# 4. a random number R is chosen. R is between 0 and the accumulated normalized value (it is normalized value plus the normalized values of the chromosome prior it)
#    greater than R
# 5. the selected individual is the first one whose accumulated normalized value (it is normalized value plus the normalized values of the chromosome prior it)
#    greater than R
# 6. repeat 4 and 5 for 2/3 times the population size
  
# @params: population, an array of chromosomes
# @return: breed_population, a new array of chromosomes

    def self.selection(population)
      population.sort! { |a, b| b.fitness <=> a.fitness }
      
      best_fitness = population[0].fitness
      least_fitness = population.last.fitness
      accumulated_fitness = 0
      
      if (best_fitness - least_fitness) > 0
        population.each do |chromosome|
          chromosome.normalized_fitness = (chromosome.fitness - least_fitness) / (best_fitness - least_fitness)
          accumulated_fitness += chromosome.normalized_fitness
        end
      else
        population.each {|chromosome| chromosome.normalized_fitness = 1 }
      end 
      
      breed_population = []
      ((population.size * 2)/3).times do
        breed_population << select_random_individual(population, accumulated_fitness)
      end
      breed_population
    end
     
# Definition: reproduction calls on Chromosome.reproduce to produce the offspring generation
# @params: breed_population, an array of chromosomes
# @return: offsprings, a new array of chromosomes
    def self.reproduction(breed_population)
      offsprings = []
      0.upto(breed_population.size/2 - 1) do |i|
        offsprings << Chromosome.reproduce(breed_population[2*i], breed_population[2*i+1])
      end
      offsprings
    end
      
# Definition: mutate_all_population will call Chromosome.mutate on each chromosome in the population 
# @params: population, an array of chromosomes
# @return: mutated_population, an array of chromosomes 
    def self.mutate_all_population(population)
      mutated_population = []
      population.each do |chromosome|
        mutated_population << Chromosome.mutate(chromosome)
      end
      mutated_population
    end
       
# Definition: select the best chromosome in the population
# @params: population, an array of chromosomes
# @return: best_chromosome, a chromosome object
    def self.select_best_chromosome(population)
      best_chromosome = population[0]
      population.each do |chromosome|
        best_chromosome = chromosome if chromosome.fitness > best_chromosome.fitness
      end
      best_chromosome
    end
    
# Definition: replace_worst_ranked replaces the worst ranked population with its offsprings
# @params: 
# population, an array of chromosomes
# offsprings, an array of chromosomes
# @return: a new population, an array of chromosomes
    def self.replace_worst_ranked(population, offsprings)
      size = offsprings.size
      population.sort! { |a, b| b.fitness <=> a.fitness }
      population = population[0..((-1*size)-1)] + offsprings
    end
           
    private unless Rails.env == 'test'
    
# Definition: given a population of chromosomes, and accumulated_normalized_fitness value of the individuals in the population, 
#            this method will select and return a random chromosome from the population
# @params: 
# population, an array of chromosomes
# accumulated_normalized_fitness, an decimal that sums normalized_fitness of individual chromosome in the population
# @return: chromosome, a chromosome object  
    def self.select_random_individual(population, accumulated_normalized_fitness)
      select_random_target = accumulated_normalized_fitness * rand
      local_acum = 0
      
      population.each do |chromosome|
        local_acum += chromosome.normalized_fitness
        return chromosome if local_acum >= select_random_target
      end
    end
       
  end
  
  
  class Chromosome
    include Comparable
    
    attr_accessor :meeting_solution
    attr_accessor :normalized_fitness
    @@factors_to_consider = nil
    @@fitness_scores_table = nil
    
    def initialize   
      @normalized_fitness = 0
      @meeting_solution = MeetingSolution.new()
      
      faculties = @@factors_to_consider[:faculties]
      attending_admits_ids = @@factors_to_consider[:attending_admits].keys
      
      faculties.each do |faculty_id, faculty|
        faculty[:schedule].each_with_index do |room_timeslot_pair, schedule_index|
          faculty[:max_students_per_meeting].times do
            random_index = rand(attending_admits_ids.length)
            admit_id = attending_admits_ids[random_index]
            @meeting_solution.add_new_mock_meeting(MockMeeting.new(faculty_id, schedule_index, admit_id))
          end
        end
      end
    end



=begin
    def self.set_factors_to_consider(factors_to_consider)
      @@factors_to_consider = factors_to_consider
    end
       
    def self.set_fitness_scores_table(fitness_scores)
      @@fitness_scores_table = fitness_scores
    end
        
    # fitness is basically a utility/heuristic value function that evaluate how good a particular solution is
    def fitness
      return @fitness if @fitness
      
      # remove duplicates in time slot for prof, get the best
      @fitness = 0
      @meeting_solution.each do |nucleotide|
        if nucleotide.admit_id
          admit = @@factors_to_consider[:attending_admits][nucleotide.admit_id]
          faculty = @@factors_to_consider[:faculties][nucleotide.faculty_id]
          meeting_possible_score = Chromosome.meeting_possible_score(admit, faculty, nucleotide.schedule_index)
          
          @fitness +=  (meeting_possible_score <= 0) ? meeting_possible_score : meeting_possible_score +
            Chromosome.admit_preference_score(@meeting_solution, admit, faculty, nucleotide.schedule_index) +
            Chromosome.faculty_preference_score(admit, faculty) +
            Chromosome.area_match_score(admit, faculty)
        end
      end
      
      @fitness
    end
    
    def self.mutate(chromosome)
      # add more stuff such as double mutation, inversion, translocation of two snippets, simulated annealing mutation rates, etc
      if Chromosome.ok_to_mutate(chromosome)
        which_mutation = Chromosome.random
        case which_mutation
        when 0...@@factors_to_consider[:chromosomal_inversion_probability]
          indexes = Chromosome.pick_two_random_indexes(chromosome)
          Chromosome.chromosomal_inversion(chromosome, indexes[0], indexes[1])
        when @@factors_to_consider[:chromosomal_inversion_probability]...
            @@factors_to_consider[:chromosomal_inversion_probability] + @@factors_to_consider[:point_mutation_probability]
          index = Chromosome.random(chromosome.length)
          Chromosome.point_mutation(chromosome, index)
        else
          index = Chromosome.random(chromosome.length - 1)
          Chromosome.reverse_two_adjacent_sequences(chromosome, index)
        end
        @fitness = nil # need to recalculate fitness value when fitness method is called
      end      
    end
    
    # Produces only ONE child chromosome
    def self.reproduce(parent1, parent2)
      if Chromosome.random < @@factors_to_consider[:double_crossover_probability]
        indexes = Chromosome.pick_two_random_indexes(parent1)        
        Chromosome.double_crossover(parent1, parent2, indexes[0], indexes[1])
      else
        splice_index = Chromosome.random(parent1.length - 2) + 1
        Chromosome.single_crossover(parent1, parent2, splice_index)
      end
    end
    
=end    
    
    # seed produces an individual solution (chromosome) for the initial population
    def self.seed
      solution_string =  Chromosome.create_solution_string # original code moved to method create_meeting_solution
      Chromosome.new(solution_string)
    end
    
    
    
    def solution_string
      self.meeting_solution.collect{ |n| n.admit_id }
    end
    
    def [](index)
      self.solution_string[index]
    end

    def <=>(other)
      self.solution_string <=> other.solution_string
    end

    def length
      self.meeting_solution.length
    end

    
    private unless Rails.env == 'test'

    # Helper method to create a nucleotide sequence
    def self.create_solution_string
      attending_admits = @@factors_to_consider[:attending_admits]
      total_number_of_seats = @@factors_to_consider[:total_number_of_seats]
      total_number_of_meetings = @@factors_to_consider[:total_number_of_meetings]
      
      solution_string = Array.new(total_number_of_seats)
      number_of_spots_per_student = (total_number_of_meetings / attending_admits.count).floor - 1
      admit_ids = (attending_admits.keys * number_of_spots_per_student).shuffle.shuffle
      
      admit_ids.each do |id|
        index = Chromosome.random(total_number_of_meetings)
        while solution_string[index] # if the spot is occupied, we find a new spot
          index = Chromosome.random(total_number_of_meetings)
        end
        solution_string[index] = id
      end
      solution_string
    end
    

=begin    
    # Fitness function related helper methods
        
    def self.meeting_possible_score(admit, faculty, schedule_index)
      timeslot = faculty[:schedule][schedule_index][:time_slot]
      if admit[:available_times].contains_set?(RangeSet.new([timeslot]))
        @@fitness_scores_table[:meeting_possible_score]
      else
        @@fitness_scores_table[:meeting_possible_penalty]
      end
    end
    
    # Score based on achieving the ADMIT's faculty preference
    def self.faculty_preference_score(admit, faculty)
      ranking = Chromosome.find_faculty_ranking(admit, faculty)
      if ranking
        @@fitness_scores_table[:faculty_ranking_weight_score] * (@@factors_to_consider[:lowest_rank_possible]+1 - ranking[:rank])
      else
        @@fitness_scores_table[:faculty_ranking_default]
      end
    end

    def self.find_faculty_ranking(admit, faculty)
      admit[:rankings].find{ |r| r[:faculty_id] == faculty[:id] }
    end
    
    # Score based on achieving the FACULTY's admit preference
    def self.admit_preference_score(meeting_solution, admit, faculty, schedule_index)
      ranking = Chromosome.find_admit_ranking(admit, faculty)
      if ranking
        @@fitness_scores_table[:admit_ranking_weight_score] * (@@factors_to_consider[:lowest_rank_possible]+1 - ranking[:rank]) +
          Chromosome.one_on_one_score(meeting_solution, admit, faculty, ranking, schedule_index) +
          Chromosome.mandatory_meeting_score(ranking)
      else
        @@fitness_scores_table[:admit_ranking_default]
      end
    end

    def self.find_admit_ranking(admit, faculty)
      faculty[:rankings].find{ |r| r[:admit_id] == admit[:id] }
    end
    
    # Score based on whether the admit's choices of area fit the professor's area of research
    def self.area_match_score(admit, faculty)
      [admit[:area1], admit[:area2]].include? faculty[:area] ? @@fitness_scores_table[:area_match_score] :
        @@fitness_scores_table[:area_match_default]
    end
    
    # Score for faculty's one-on-one meeting request met
    def self.one_on_one_score(meeting_solution, admit, faculty, ranking, schedule_index)
      if ranking[:one_on_one]
        people_in_meeting = Chromosome.get_people_in_meeting(meeting_solution, faculty, schedule_index)
        if Chromosome.only_one_person_in_meeting(people_in_meeting, admit)
          @@fitness_scores_table[:one_on_one_score]
        else
          @@fitness_scores_table[:one_on_one_penalty]
        end
      else
        @@fitness_scores_table[:one_on_one_default]
      end
    end

    def self.get_people_in_meeting(meeting_solution, faculty, schedule_index)
      meeting_solution.find_all{ |n| n.faculty_id == faculty[:id] and n.schedule_index == schedule_index }.collect{ |n| n.admit_id }
    end
    
    def self.only_one_person_in_meeting(people_in_meeting, admit)
      people_in_meeting.uniq.delete_if{ |id| id == nil } == [admit[:id]]
    end

    # Score for faculty's mandatory meeting request met
    def self.mandatory_meeting_score(ranking)
      ranking[:mandatory] ? @@fitness_scores_table[:mandatory_score] : @@fitness_scores_table[:mandatory_default]
    end

    def self.remove_duplicates(meeting_solution)
      # to be implemented or not
    end    

    
    # Methods for generating children
    
    def self.single_crossover(parent1, parent2, splice_index)
      Chromosome.new(parent1[0...splice_index] + parent2[splice_index..-1])
    end
    
    def self.double_crossover(parent1, parent2, splice_index1, splice_index2)
      Chromosome.new(parent1[0...splice_index1] + parent2[splice_index1...splice_index2] + parent1[splice_index2..-1])
    end
    
    
    # Methods for generating mutations
    
    def self.reverse_two_adjacent_sequences(chromosome, index)
      Chromosome.chromosomal_inversion(chromosome, index, index+1)
    end
    
    def self.chromosomal_inversion(chromosome, index1, index2)    
      partially_inverted_solution_string = chromosome[index1..index2].reverse
      solution_string = chromosome[0...index1] + partially_inverted_solution_string + chromosome[index2+1..-1]
      return Chromosome.new(solution_string)
    end
    
    def self.point_mutation(chromosome, index)
      admit_id = @@factors_to_consider[:attending_admits].keys.shuffle.shuffle.fetch(0)
      solution_string = chromosome.solution_string
      solution_string[index] = admit_id
      return Chromosome.new(solution_string)
    end

    
    # Abstracted methods for easier stubbing in Rspec tests

    def self.ok_to_mutate(chromosome)
      chromosome.normalized_fitness && Chromosome.random < ((1 - chromosome.normalized_fitness) * 0.3)
    end
    
    def self.random(params=nil)
      rand(params)
    end
    
    def self.pick_two_random_indexes(sample_chromosome)
      index1 = index2 = rand(sample_chromosome.length - 5) + 1
      while index2 <= index1+1
        index2 = rand(sample_chromosome.length - 2) + 1
      end
      [index1, index2]
    end
    
  end
  
  
  
 
  class Nucleotide    
    def initialize(data)
      @data = data
    end
    
    def faculty_id
      @data[0]
    end
    
    def schedule_index
      @data[1]
    end
    
    def admit_id
      @data[2]
    end    
  end
=end 
  end

  class MeetingSolution
    def initialize
      @meeting_soluiton = Array.new()
    end
    
    def length
      @meeting_solution.length
    end
    
    def add_new_mock_meeting(mock_meeting)
      @meeting_solution << mock_meeting
    end 
  end
 
  class MockMeeting
    attr_accessor :faculty_id
    attr_accessor :schedule_index
    attr_accessor :admit_id
     
    def initialize(faculty_id, schedule_index, admit_id)
      @faculty_id = faculty_id
      @schedule_index = schedule_index
      @admit_id = admit_id
    end
  end

  
end
