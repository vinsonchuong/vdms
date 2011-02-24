module MeetingsScheduler
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
        
  class GeneticAlgorithm
    
    # Definition: initializes the Chromosome class variables. This must be called before calling ＧＡrun.
    # @params:
    # => factors_to_consider: a hash specified in the documentation
    # => fitness_scores_table: a scores hash specified in the documentation
    # @returns: 
    # => N/A 
    
    # NOTE: NOT THE SAME AS class instance initialize!
    def self.initialize (factors_to_consider, fitness_scores_table)
      Chromosome.set_factors_to_consider(factors_to_consider)
      Chromosome.set_fitness_scores_table(fitness_scores_table)
    end
    
    # Definition: runs genetic algorithm. runs generate the most optimal solution to the scheduling problem.
    # @params: 
    # => population_size: an int to specify the size of chromosome population  
    # => total_generation: an int to specify how many generation to run the algorithm
    # @returns: 
    # => the best chromosome.
    def self.run(population_size, total_generations)
      population = []
      puts "GA generating population with random chromosomes..."
      population_size.times { population << Chromosome.seed }
      
      puts "GA casting natural selection and genetic recombination..."    
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
  
    # @params: 
    # => population, an array of chromosomes
    # @return: 
    # => breed_population, a new array of chromosomes
    def self.selection(population)
      population.sort! # <=> implemented in Chromosome, so can directly call sort
            
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
    # @params: 
    # => breed_population, an array of chromosomes
    # @return: 
    # => offsprings, a new array of chromosomes
    def self.reproduction(breed_population)
      0.upto(breed_population.size/2 - 1).collect{ |i| Chromosome.reproduce(breed_population[2*i], breed_population[2*i+1]) }
    end
      
    # Definition: mutate_all_population will call Chromosome.mutate on each chromosome in the population 
    # @params: 
    # => population, an array of chromosomes
    # @return: 
    # => mutated_population, an array of chromosomes 
    def self.mutate_all_population(population)
      population.collect{ |chromosome| Chromosome.mutate(chromosome) }
    end
       
    # Definition: select the best chromosome in the population
    # @params: 
    # => population, an array of chromosomes
    # @return: 
    # => best_chromosome, a chromosome object
    def self.select_best_chromosome(population)
      population.max_by { |chromosome| chromosome.fitness }
    end
    
    # Definition: replace_worst_ranked replaces the worst ranked population with its offsprings
    # @params: 
    # => population, an array of chromosomes
    # => offsprings, an array of chromosomes
    # @return: 
    # => a new population, an array of chromosomes
    def self.replace_worst_ranked(population, offsprings)
      size = offsprings.size
      population = population.sort[0..((-1*size)-1)] + offsprings
    end
           
    private unless Rails.env == 'test'
    
    # Definition: given a population of chromosomes, and accumulated_normalized_fitness value of the individuals in the population, 
    #            this method will select and return a random chromosome from the population
    # @params: 
    # => population, an array of chromosomes
    # => accumulated_normalized_fitness, an decimal that sums normalized_fitness of individual chromosome in the population
    # @return: 
    # => chromosome, a chromosome object  
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
    end

    def self.seed
      Chromosome.new(Chromosome.create_solution_string)
    end
    
    def solution_string
      @meeting_solution.collect{ |nucleotide| nucleotide.admit_id }
    end

    def [](index)
      # @return: an element or subarray of solution_string
      self.solution_string[index]
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
      # remove duplicates in time slot for prof, get the best
      #reduced_meeting_solution = Chromosome.remove_duplicates(self.solution_string)
      
      #@fitness = @meeting_solution.inject(0) do |fitness, nucleotide|
      #  fitness +=  Chromosome.fitness_of_nucleotide(nucleotide, @meeting_solution)
      #end
    
      #@fitness = reduced_meeting_solution.inject(0) do |fitness, nucleotide|
      #  fitness +=  Chromosome.fitness_of_nucleotide(nucleotide, @meeting_solution)
      #end
      #@fitness
      rand(100)
    end
  
    # Definition: Decides with probabilities defined in factors_to_consider HOW to mutate a chromosome, and calls the appropriate mutation method
    # @params: 
    # => a chromosome
    # @return: 
    # => a new Chromosome object with the appropriate mutation if it is unfit
    # => the old chromosome if it has good fitness value
    def self.mutate(chromosome)       
      if Chromosome.ok_to_mutate(chromosome)
        puts "about to mutate"
        which_mutation = rand
        case which_mutation
        when 0...@@factors_to_consider[:chromosomal_inversion_probability]            
          index1, index2 = [rand(chromosome.length), rand(chromosome.length)].sort
          Chromosome.chromosomal_inversion(chromosome, index1, index2)        
        when @@factors_to_consider[:chromosomal_inversion_probability]...(@@factors_to_consider[:chromosomal_inversion_probability] + @@factors_to_consider[:point_mutation_probability])
          index = rand(chromosome.length)
          Chromosome.point_mutation(chromosome, index)
        else
          index = rand(chromosome.length-1)
          Chromosome.reverse_two_adjacent_sequences(chromosome, index)
        end
      else
        puts "did not mutate"
        chromosome
      end      
    end

    # Definition: Decides with probabilities defined in factors_to_consider HOW to reproduce,
    #             and calls the appropriate reproduction method
    # @params: Two parent chromosomes
    # @return: only ONE new Chromosome object with the appropriate reproduction operation performed
    def self.reproduce(parent1, parent2)
      if rand < @@factors_to_consider[:double_crossover_probability]
        splice_index1, splice_index2 = [rand(parent1.length - 1), rand(parent1.length - 1)].sort       
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
      number_of_spots_per_admit = @@factors_to_consider[:number_of_spots_per_admit] # from the threshold?
      
      solution_string = Array.new(total_number_of_seats)
      admit_ids = (attending_admits.keys * number_of_spots_per_admit).shuffle.shuffle  
      
      if admit_ids.length < total_number_of_seats
        remaining_empty_seats = total_number_of_seats - admit_ids.length
        extra_accommodation = [] 
        remaining_empty_seats.times { extra_accommodation << admit_ids[rand(admit_ids.length)] }
        admit_ids += extra_accommodation
      end
      
      total_number_of_seats.times {|index| solution_string[index] = admit_ids[index] } if total_number_of_seats > 0
      puts solution_string.inspect
      solution_string    
    end
    
    
    # Definition: Determines whether a chromosome is 'unfit enough' for a mutation
    # @params: 
    # => a Chromosome
    # @return: 
    # => true or false
    def self.ok_to_mutate(chromosome)
      #chromosome.normalized_fitness && rand < ((1 - chromosome.normalized_fitness) * 0.3)
      true
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
      mutated_solution_string = chromosome[0...index1] + partially_inverted_solution_string + chromosome[index2+1..-1]
      Chromosome.new(mutated_solution_string)
    end
    
    # Definition: Performs a point mutation on one sequence in a Chromosome
    # @params: 
    # => a Chromosome
    # @return: 
    # => a new Chromosome
    def self.point_mutation(chromosome, index)
      admit_id = @@factors_to_consider[:attending_admits].keys.shuffle.shuffle.fetch(0)
      mutated_solution_string = chromosome.solution_string
      mutated_solution_string[index] = admit_id
      Chromosome.new(mutated_solution_string)
    end
    
    #############################
    # Reproduction Help Methods #
    #############################
    
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
  

  class Nucleotide    
    attr_reader :faculty
    attr_accessor :admit
    attr_reader :schedule_index

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

    def extract
      [@faculty, @schedule_index, @admit]
    end
  end
  
end
