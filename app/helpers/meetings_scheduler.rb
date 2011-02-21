module MeetingsScheduler

=begin   
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
#                     :total_number_of_seats => an int,
#                     :chromosomal_inversion_probability => a decimal range from 0 to 1, 
#                     :point_mutation_probability => a decimal range from 0 to 1,
#                     :double_crossover_probability => a decimal range from 0 to 1,
#                    }
#                    The structure of :attending_admits looks like:
#                    { id1 => { :id => integer of the admit's database id, same as id1,
#                               :name => a string of the admit's name,
#                               :rankings => array of hashes of the admit's preference list,
#                               :available_times => range_set that encodes the admit's 24 hour availability
#                             },
#                      id2 => { :id => integer of the admit's database id, same as id2,
#                               :name => a string of the admit's name,
#                               :rankings => array of hashes of the admit's preference list,
#                               :available_times => range_set that encodes the admit's 24 hour availability
#                             },
#                    .
#                    .
#                     etc, where id1 and id2 are ints of the admit's database id,              
#                    }
#                    The structure of :faculties looks like:
#                    { fid1 => { :id => integer of the faculty's database id, same as fid1,
#                                :max_students_per_meeting => an int specifying the maximum number of student allowed per meeting for this faculty,
#                                :rankings => array of hashes of the faculty's preference list,
#                                :schedule => [{ :room => 'room1', :time_slot => timerange },
#                                              { :room => 'room2', :time_slot => timerange } ....etc],
#                              },
#                     :fid2 => { :id => integer of the faculty's database id, same as fid2,
#                                :max_students_per_meeting => an int specifying the maximum number of student allowed per meeting for this faculty,
#                                :rankings => array of hashes of the faculty's preference list,
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
 
#      def initialize(factors_to_consider, population_size, total_generations)        
#        @total_generations = total_generations
#        @factors_to_consider = factors_to_consider
#        @population = Scheduler.create_population(@factors_to_consider, population_size)
#      end


# Definition: produces optimum meeting arrangement
# @params: NA
# @return: a list of meeting objects
      
#      def make_meetings()
#        best_chromosome = GeneticAlgorithm.run(@population, @total_generations, @factors_to_consider)
#        Scheduler.create_meetings(best_chromosome)
#      end
      
#      private unless Rails.env == 'test'
      
# Definition: convert a chromosome to a list of meeting
# @params: a chromosome
# @return: a list of meeting object

#      def self.create_meetings(best_chromosome)
#        meetings = []
#        best_chromosome.meeting_solution.each do |nucleotide|
#          if nucleotide.admit_id
#            admit = @factors_to_consider[:attending_admits][nucleotide.admit_id]
#            faculty = @factors_to_consider[:faculties][nucleotide.faculty_id]
#            schedule = faculty[:schedule][nucleotide.schedule_index]
            
#            m = meetings[-1]
#            if Scheduler.need_a_new_meeting?(m, faculty, schedule)
#              m = Scheduler.set_up_new_meeting(faculty, schedule)
#            end
            
            # add admits, not sure if this is the proper way to do it
#            Admit.find(admit[:id]).meetings << m
            
#          end
#        end
        
#       return meetings
#      end
      
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
      
      def self.create_population(factors_to_consider, population_size)
        population = []
        Chromosome.set_factors_to_consider(factors_to_consider)
        Chromosome.set_fitness_scores_table(fitness_scores)
        population_size.times do
          population << Chromosome.seed()
        end
        population
#      end

#  end
  





# Definition: generates Meeting objects
# @params:
# best_solution: a Chromosome representing the best meeting solution
# @returns: an array of initialized Meeting objects, NOT yet saved to database
  def self.generate_meetings(best_chromosome)
    meetings = []
    best_chromosome.meeting_solution.each do |nucleotide|
    if nucleotide.admit_id?
      faculty, schedule_index, admit = nucleotide.extract
      schedule = faculty[:schedule][schedule_index]
      
      if MeetingsScheduler.need_a_new_meeting?(meetings[-1], faculty, schedule)
        meetings << MeetingsScheduler.set_up_new_meeting(faculty, schedule)
      end
      
      meetings[-1].admits << Admit.find(admit[:id])
    end         
    return meetings
  end
        
# Definition: initializes a new Meeting object
# @params:
# faculty: a hash of a Faculty model.  See documentation for layout.
# schedule: a hash of a Faculty schedule entry.  See documentation for layout.
# @returns: a new Meeting object
  def self.set_up_new_meeting(faculty, schedule)
    meeting = Meeting.new
    meeting.faculty = Faculty.find(faculty[:id])
    meeting.room = schedule[:room]
    meeting.time = schedule[:time_range].begin
    return meeting
  end
        
# Definition: determines whether a new meeting is needed
# @params:
# current_meeting: a Meeting object.
# faculty: a hash of a faculty.  See documentation for layout.
# schedule: a hash of a Faculty schedule entry.  See documentation for layout.
# @returns: true, if the current_meeting's faculty and schedule time do NOT match, false otherwise
  def self.need_a_new_meeting?(current_meeting, faculty, schedule)
    if current_meeting
      current_meeting.faculty_id != faculty[:id] or current_meeting.time != schedule[:time_range].begin
    end
  end

=end
        
  class GeneticAlgorithm
# Definition: initializes the Chromosome class variables
# @params:
# factors_to_consider: a hash specified in the documentation
# fitness_scores_table: a scores hash specified in the documentation
# @returns: N/A
    # NOTE: NOT THE SAME AS class instance initialize!
    def self.initialize (factors_to_consider, fitness_scores_table)
      Chromosome.set_factors_to_consider(factors_to_consider)
      Chromosome.set_fitness_scores_table(fitness_scores_table)
    end
    
# Definition: run is the main execution of the algorithm. Calling run will theoretically output the best solution available after total_generations 
#
# @params: 
# population: an array of chromosomes  
# total_generation: an int to specify how many generation to run the algorithm
# factors_to_consider: a hash, the specific structure of this hash, please refer to Scheduler.new method
# @returns: the best chromosome object
    def self.run(population_size, total_generations)
      population = []
      population_size.times { population << Chromosome.seed }
      
      
      total_generations.times do
        parents = GeneticAlgorithm.selection(population)
        offsprings = GeneticAlgorithm.reproduction(parents)
        population = GeneticAlgorithm.mutate_all_population(population)
        population = GeneticAlgorithm.replace_worst_ranked(population, offsprings) 
      end
      #puts population.inspect
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
      # <=> implemented in Chromosome, so can directly call sort
      population.sort!
            
      best_fitness = population[0].fitness
      least_fitness = population.last.fitness
      accumulated_fitness = 0
            
      if (best_fitness - least_fitness) > 0
        population.each do |chromosome|
          chromosome.normalized_fitness = (chromosome.fitness - least_fitness) / (best_fitness - least_fitness)
          accumulated_fitness += chromosome.normalized_fitness
        end 
      else
        population.each { |chromosome| chromosome.normalized_fitness = 1 }
      end 
    
      ((population.size * 2)/3).times.collect{ select_random_individual(population, accumulated_fitness) }
    end
     
# Definition: reproduction calls on Chromosome.reproduce to produce the offspring generation
# @params: breed_population, an array of chromosomes
# @return: offsprings, a new array of chromosomes
    def self.reproduction(breed_population)
      0.upto(breed_population.size/2 - 1).collect{ |i| Chromosome.reproduce(breed_population[2*i], breed_population[2*i+1]) }
    end
      
# Definition: mutate_all_population will call Chromosome.mutate on each chromosome in the population 
# @params: population, an array of chromosomes
# @return: mutated_population, an array of chromosomes 
    def self.mutate_all_population(population)
      population.collect{ |chromosome| Chromosome.mutate(chromosome) }
    end
       
# Definition: select the best chromosome in the population
# @params: population, an array of chromosomes
# @return: best_chromosome, a chromosome object
    def self.select_best_chromosome(population)
      population.max_by { |chromosome| chromosome.fitness }
    end
    
# Definition: replace_worst_ranked replaces the worst ranked population with its offsprings
# @params: 
# population, an array of chromosomes
# offsprings, an array of chromosomes
# @return: a new population, an array of chromosomes
    def self.replace_worst_ranked(population, offsprings)
      size = offsprings.size
            
      # <=> implemented in Chromosome, so can directly call sort
      population = population.sort[0..((-1*size)-1)] + offsprings
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
  
# Definition: Initializes a new Chromosome object
# @params: solution_string, an array of admit_id's and nils
# @return: new Chromosome Object    
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

# Definition: Sets the factors_to_consider class hash for all chromosomes to use
# @params: factors_to_consider hash, internals described in MeetingsScheduler::Scheduler documentation
# @return: NA    
    def self.set_factors_to_consider(factors_to_consider)
      @@factors_to_consider = factors_to_consider
    end
       
# Definition: Sets the fitness_scores_table class hash for all chromosomes to use to evaluate a solution's fitness
# @params: fitness_scores hash, internals described in MeetingsScheduler::Scheduler documentation
# @return: NA    
    def self.set_fitness_scores_table(fitness_scores)
      @@fitness_scores_table = fitness_scores
    end

# Definition: Creates a solution_string, and uses it to create a new Chromosome object
# @params: NA
# @return: an individual new solution (chromosome) for the initial population
  def self.seed
    solution_string =  Chromosome.create_solution_string
    Chromosome.new(solution_string)
  end

# Definition: Extracts the admit_id's from @meeting_solution
# @params: NA
# @return: an array of admit_id's that corresponds to the Chromosome object's @meeting_solution
  def solution_string
    @meeting_solution.collect{ |nucleotide| nucleotide.admit_id }
  end

# Definition: Accesses solution_string as an array
# @params: index or range
# @return: an element or subarray of solution_string
  def [](index)
    self.solution_string[index]
  end

# Definition: Allows comparison between two Chromosome objects
# @params: a second chromosome
# @return: -1, 0, or 1 (see documentation found in Comparable module)
  def <=>(other)
    self.fitness <=> other.fitness
  end

# Definition: The 'length,' or number of Nucleotides, in a Chromosome object
# @params: a second chromosome
# @return: -1, 0, or 1 (see documentation found in Comparable module)
  def length
    @meeting_solution.length
  end

# Definition: A utility/heuristic value function that evaluates how good a particular solution is
# @params: NA
# @return: a fitness value as a Float
  def fitness
    return @fitness if @fitness
    # remove duplicates in time slot for prof, get the best
    reduced_meeting_solution = Chromosome.remove_duplicates(self.solution_string)
    
    @fitness = reduced_meeting_solution.inject(0) do |fitness, nucleotide|
      fitness +=  Chromosome.fitness_of_nucleotide(nucleotide, @meeting_solution)
    end
    
    @fitness
  end
  
# Definition: Decides with probabilities defined in factors_to_consider HOW to mutate a chromosome, and calls the appropriate mutation method
# @params: chromosome
# @return: a new Chromosome object with the appropriate mutation
  def self.mutate(chromosome)     
    # add more stuff such as double mutation, inversion,
    # translocation of two snippets, simulated annealing mutation rates, etc, in the future
  
    if Chromosome.ok_to_mutate(chromosome)
      which_mutation = rand
      
      case which_mutation
      when 0...@@factors_to_consider[:chromosomal_inversion_probability]            
        index1, index2 = Chromosome.pick_two_random_indexes(chromosome)
        Chromosome.chromosomal_inversion(chromosome, index1, index2)        
      when @@factors_to_consider[:chromosomal_inversion_probability]...@@factors_to_consider[:chromosomal_inversion_probability] +
          @@factors_to_consider[:point_mutation_probability]
        index = rand(chromosome.length)
        Chromosome.point_mutation(chromosome, index)
      else
        index = rand(chromosome.length - 1)
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
        splice_index1, splice_index2 = Chromosome.pick_two_random_indexes(parent1)        
        Chromosome.double_crossover(parent1, parent2, splice_index1, splice_index2)
      else
        splice_index = rand(parent1.length - 2)+1
        Chromosome.single_crossover(parent1, parent2, splice_index)
      end
    end
    

    private unless Rails.env == 'test'

# Definition: Helper method to create a nucleotide sequence 
# @params: NA
# @return: a shuffled array of admit_id's and nils
    
    def self.create_solution_string
      attending_admits = @@factors_to_consider[:attending_admits]
      total_number_of_seats = @@factors_to_consider[:total_number_of_seats]
      number_of_spots_per_admit = @@factors_to_consider[:number_of_spots_per_admit]
      solution_string = Array.new(total_number_of_seats)
      
      admit_ids = (attending_admits.keys * number_of_spots_per_admit).shuffle.shuffle
      admit_ids.each do |id|
        index = rand(total_number_of_seats)
        while solution_string[index] # if the spot is occupied, we find a new spot
          index = rand(total_number_of_seats)
        end
        solution_string[index] = id
      end

      # After giving each admit some fair number of spots, fill up the remaining  empty seats 
      solution_string.each_with_index do |admit_id, index|
        if admit_id.nil?
          solution_string[index] = attending_admits.keys[rand(attending_admits.length)]
        end
      end  
      solution_string
    end
     
    
    # Fitness function related helper methods

# Definition: Determines the fitness score of a single nucleotide based on the criterion subscores 
# @params: a Nucleotide object
# @return: a Float score
    def self.fitness_of_nucleotide(nucleotide, meeting_solution)
      if nucleotide.admit
        is_meeting_possible_score = Chromosome.is_meeting_possible_score(nucleotide)
        
        return (is_meeting_possible_score <= 0) ? is_meeting_possible_score : is_meeting_possible_score +
          Chromosome.admit_preference_score(meeting_solution, nucleotide) +
          Chromosome.faculty_preference_score(nucleotide) +
          Chromosome.area_match_score(nucleotide)
        rand(100)+1
      else
        0
      end
    end
    
# Definition: Determines whether an admit-faculty arrangement encoded by a Nucleotide
#             is physically possible given the faculty's and admit's time constraints, and
#             returns the appropriate score
# @params: a Nucleotide object
# @return: a Float score
    def self.is_meeting_possible_score(nucleotide)
      faculty, schedule_index, admit = nucleotide.extract
      faculty_time_slot = faculty[:schedule][schedule_index][:time_slot]
            
      return admit[:available_times].contain_set?(RangeSet.new([faculty_time_slot])) ?
      @@fitness_scores_table[:is_meeting_possible_score] : @@fitness_scores_table[:is_meeting_possible_penalty] 
    end

# Definition: Finds an ADMIT's faculty ranking if it exists
# @params: an Admit and Faculty hash
# @return: a Ranking hash or nil
    def self.find_faculty_ranking(admit, faculty)
      admit[:rankings].find { |ranking| ranking[:faculty_id] == faculty[:id] }
    end

# Definition: Finds a FACULTY's admit ranking if it exists
# @params: an Admit and Faculty hash
# @return: a Ranking hash or nil
    def self.find_admit_ranking(admit, faculty)
      faculty[:rankings].find { |ranking| ranking[:admit_id] == admit[:id] }
    end

# Definition: Determines whether an ADMIT's faculty preference is met, and returns the appropriate score
# @params: a Nucleotide object
# @return: a Float score
    def self.faculty_preference_score(nucleotide)
      faculty, schedule_index, admit = nucleotide.extract      
      ranking = Chromosome.find_faculty_ranking(admit, faculty)
      
      if ranking
        @@fitness_scores_table[:faculty_ranking_weight_score] * (faculty[:rankings].count+1 - ranking[:rank])
      else
        @@fitness_scores_table[:faculty_ranking_default]
      end
    end

# Definition: Determines whether a FACULTY's admit preference is met,
#             computes the appropriate sub-criterions, and
#             returns the appropriate score
# @params: a Nucleotide object
# @return: a Float score
    def self.admit_preference_score(meeting_solution, nucleotide)
      faculty, schedule_index, admit = nucleotide.extract
      ranking = Chromosome.find_admit_ranking(admit, faculty)
      
      if ranking
        @@fitness_scores_table[:admit_ranking_weight_score] * (faculty[:rankings].count+1 - ranking[:rank]) +
          Chromosome.one_on_one_score(meeting_solution, nucleotide, ranking) +
          Chromosome.mandatory_meeting_score(ranking)
      else
        @@fitness_scores_table[:admit_ranking_default]
      end
    end

# Definition: Determines whether a FACULTY's admit ranking also requests a one-to-one meeting,
#             checks if that criterion is met, and assigns the appropriate score
# @params: a Chromosome's meeting solution (array of Nucleotides), a Nucleotide, and a Ranking hash
# @return: a Float score
    def self.one_on_one_score(meeting_solution, nucleotide, ranking)
      if ranking[:one_on_one]
        faculty, schedule_index, admit = nucleotide.extract
        admits_in_meeting = Chromosome.find_admits_in_meeting(meeting_solution, faculty, schedule_index)

        Chromosome.only_one_admit_in_meeting(admits_in_meeting, admit) ?
        @@fitness_scores_table[:one_on_one_score] : @@fitness_scores_table[:one_on_one_penalty]
      else
        @@fitness_scores_table[:one_on_one_default]
      end
    end

# Definition: Determines whether a Faculty's area of research and Admit's
#             areas of interest match, and returns the appropriate score
# @params: an Admit and Faculty hash
# @return: a Float score
    def self.area_match_score(nucleotide)
      faculty, schedule_index, admit = nucleotide.extract
      
      [admit[:area1], admit[:area2]].include?(faculty[:area]) ?
      @@fitness_scores_table[:area_match_score] : @@fitness_scores_table[:area_match_default]
    end
    
# Definition: Finds the admits that are assigned to a specific schedule slot for a specific faculty
# @params: a Chromosome's meeting solution (array of Nucleotides), a Faculty hash, and a schedule_index (int)
# @return: an array of admit_id's
    def self.find_admits_in_meeting(meeting_solution, faculty, schedule_index)
      meeting_solution.find_all{ |nucleotide| nucleotide.faculty_id == faculty[:id] and
        nucleotide.schedule_index == schedule_index }.collect{ |nucleotide| nucleotide.admit_id }
    end
    
# Definition: Determines whether an array of admit_id's contains only one unique admit_id
# @params: an array of admit_id's (people_in_meeting) and an Admit hash
# @return: true or false
    def self.only_one_admit_in_meeting(admits_in_meeting, admit)
      admits_in_meeting.uniq.delete_if{ |id| id.nil? } == [admit[:id]]
    end

# Definition: Determines whether a FACULTY's admit ranking is a mandatory request,
#             checks if that criterion is met, and assigns the appropriate score
# @params: a Ranking hash
# @return: a Float score
    def self.mandatory_meeting_score(ranking)
      ranking[:mandatory] ? @@fitness_scores_table[:mandatory_score] : @@fitness_scores_table[:mandatory_default]
    end



    # Methods for returning a meeting_solution with duplicates removed
    
# Definition: Removes all non-optimal admit_ids from all nucleotides
# @params: a Chromosome's solution_string
# @return: a new Chromosome meeting_solution (array of Nucleotides)
    def self.remove_duplicates(solution_string)
      new_meeting_solution = Chromosome.new(solution_string).meeting_solution
      @@factors_to_consider[:faculties].each do |faculty_id, faculty|
        Chromosome.remove_duplicate_admits_from_faculty!(new_meeting_solution, faculty)
      end
      new_meeting_solution
    end
    
# Definition: Removes all non-optimal admit_ids from all nucleotides belonging to the same Faculty
# @params: a meeting_solution and a Faculty hash
# @return: NA
    def self.remove_duplicate_admits_from_faculty!(new_meeting_solution, faculty)
      duplicate_admit_ids = Chromosome.get_duplicate_admit_ids(new_meeting_solution, faculty)
      duplicate_admit_ids.each do |admit_id|
        Chromosome.remove_duplicate_spots_for_admit!(new_meeting_solution, faculty, admit_id)
      end
    end

# Definition: Removes all non-optimal admit_ids from all nucleotides that have the same faculty_id and admit_id
# @params: a meeting_solution, Faculty hash, and admit_id (int)
# @return: NA
    def self.remove_duplicate_spots_for_admit!(new_meeting_solution, faculty, admit_id)
      duplicate_nucleotides = Chromosome.get_duplicate_nucleotides_for_admit(new_meeting_solution, faculty, admit_id)
      best_nucleotide = Chromosome.pick_out_best_nucleotide(duplicate_nucleotides, new_meeting_solution)
      Chromosome.reset_non_optimal_nucleotides!(duplicate_nucleotides, best_nucleotide)
    end
    
# Definition: Reset all non-optimal nucleotides' admit_ids to nil, given a best_nucleotide to compare
# @params: an array of duplicate Nucleotides and a 'best' Nucleotide
# @return: NA
    def self.reset_non_optimal_nucleotides!(duplicate_nucleotides, best_nucleotide)
      duplicate_nucleotides.each do |nucleotide|
        if nucleotide.schedule_index != best_nucleotide.schedule_index
          nucleotide.admit = nil
        end
      end
    end
    
# Definition: Picks out the optimal nucleotide from an set of duplicate Nucleotides for an Admit and Faculty
# @params: an array of duplicate Nucleotides
# @return: a Nucleotide
    def self.pick_out_best_nucleotide(duplicate_nucleotides, meeting_solution)
      duplicate_nucleotides.max_by{ |nucleotide| Chromosome.fitness_of_nucleotide(nucleotide, meeting_solution) }
    end

# Definition: Returns an array of Nucleotide that have the same Faculty_id and Admit_id
# @params: a meeting_solution, a Faculty hash, and an admit_id (int)
# @return: an array of Nucleotides
    def self.get_duplicate_nucleotides_for_admit(new_meeting_solution, faculty, admit_id)
      new_meeting_solution.find_all{ |nucleotide| nucleotide.faculty_id == faculty[:id] and nucleotide.admit_id == admit_id }
    end
    
# Definition: Finds admit_ids that appear duplicate in a set of Nucleotides with the same faculty_id
# @params: a meeting_solution and a Faculty hash
# @return: an array of admit_ids (int)
    def self.get_duplicate_admit_ids(new_meeting_solution, faculty)
      admit_ids = new_meeting_solution.find_all{ |nucleotide| nucleotide.faculty_id == faculty[:id] }.collect{ |nucleotide| nucleotide.admit_id }
      return Chromosome.dups(admit_ids)
    end

# Definition: Returns a list of elements that appear duplicate in an Array
# @params: an Array
# @return: an Array
    def self.dups(enumerable)
      enumerable.inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
    end
    
 

  
    # Methods for generating children/reproduction
    
# Definition: Performs a single crossover
# @params: 2 parent Chromosomes and a splice index (int)
# @return: a new Chromosome
    def self.single_crossover(parent1, parent2, splice_index)
      Chromosome.new(parent1[0...splice_index] + parent2[splice_index..-1])
    end
    
# Definition: Performs a double crossover
# @params: 2 parent Chromosomes and two splice indexes (int)
# @return: a new Chromosome
    def self.double_crossover(parent1, parent2, splice_index1, splice_index2)
      Chromosome.new(parent1[0...splice_index1] + parent2[splice_index1...splice_index2] + parent1[splice_index2..-1])
    end
    
    
    # Methods for generating mutations
    
# Definition: Performs a reversal on two adjacent sequences of a Chromosome
# @params: a Chromosome
# @return: a new Chromosome
    def self.reverse_two_adjacent_sequences(chromosome, index)
      Chromosome.chromosomal_inversion(chromosome, index, index+1)
    end
    
# Definition: Performs an inversion on a stretch of sequences along a Chromosome
# @params: a Chromosome
# @return: a new Chromosome
    def self.chromosomal_inversion(chromosome, index1, index2)        
      partially_inverted_solution_string = chromosome[index1..index2].reverse
      mutated_solution_string = chromosome[0...index1] + partially_inverted_solution_string + chromosome[index2+1..-1]
      Chromosome.new(mutated_solution_string)
    end
    
# Definition: Performs a point mutation on one sequence in a Chromosome
# @params: a Chromosome
# @return: a new Chromosome
    def self.point_mutation(chromosome, index)
      admit_id = @@factors_to_consider[:attending_admits].keys.shuffle.shuffle.fetch(0)
      solution_string = chromosome.solution_string
      solution_string[index] = admit_id
      Chromosome.new(solution_string)
    end

  
    # Abstracted methods for easier stubbing in Rspec tests

# Definition: Determines whether a chromosome is 'unfit enough' for a mutation
# @params: a Chromosome
# @return: true or false
    def self.ok_to_mutate(chromosome)
      chromosome.normalized_fitness && rand < ((1 - chromosome.normalized_fitness) * 0.3)
    end
    
# Definition: Picks two random indexes that allow for LEGAL double crossovers and chromosomal inversions
# @params: a Chromosome
# @return: an array of 2 random numbers from 1 to chromosome.length-2
    def self.pick_two_random_indexes(sample_chromosome)
      index1 = rand(sample_chromosome.length) + 1
      index2 = rand(sample_chromosome.length) + 1
      [index1, index2].sort
    end
  end
  

  class Nucleotide    
    attr_reader :faculty
    attr_accessor :admit
    attr_reader :schedule_index

    def initialize(faculty, schedule_index, admit)
      @faculty = faculty
      @schedule_index = schedule_index
      @admit = admit
    end

    def admit_id
      @admit ? @admit[:id] : nil
    end

    def faculty_id
      @faculty[:id]
    end

    def extract
      [@faculty, @schedule_index, @admit]
    end
  end
  
end
