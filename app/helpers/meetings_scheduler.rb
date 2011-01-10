module MeetingsScheduler
  
  class Scheduler
      attr_accessor :population
      attr_accessor :population_size
      attr_accessor :total_generations
      
      # factors_to_consier is a hash that allows us use factors as keys to lookup its values
      # example of usage:
      # total_admits = factors_to_consider[:total_admits]
      # attending_admits = factors_to_consider[:attending_admits]
      # number_of_spots_per_student = factors_to_consider[:number_of_spots_per_student]
      def initialize(factors_to_consider, population_size, total_generations)        
        @population = Scheduler.create_population(@factors_to_consider)
        @total_generations = total_generations
        @population_size = population_size
      end
      
      def make_meetings()
        best_chromosome = GeneticAlgorithm.run(@population, @total_generations)
        Scheduler.create_meetings!(best_chromosome)
      end
      
      private unless Rails.env == 'test'
      
      def self.create_meetings!(best_chromosome)
        #to be implemented

        ## @chromosome_map = { faculty_id => first_position_on_chromosome }
        @chromosome_map.each do |faculty_id, chromosome_position|
          
          faculty = Faculty.find(faculty_id)
          chunk_length = @faculty.max_students_per_meeting          
          chromosome_segment = best_chromosome[chromosome_position...(chromosome_position + @faculty.schedule*chunk_length)]
          counter = 0
          
          chromosome_segment.each_slice(chunk_length) do |chunk|
            schedule = faculty.schedule[counter]

            meeting = faculty.meetings.new
            meeting.room = schedule[1]
            meeting.time = schedule[0].begin
            
            chunk.each { |admit_id| meeting.admits << Admit.find(admit_id) }
            meeting.save
            
            counter += 1
          end
          
        end                
      end
      
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
    # run is the main execution of the algorithm. Calling run will theoritically output the best solution available after 
    # total_generations 
    def self.run(population, total_generations, factors_to_consider)
      total_generations.times do
        parents = GeneticAlgorithm.selection(population)
        offsprings = GeneticAlgorithm.reproduction(parents)
        population = GeneticAlgorithm.mutate_all_population(population, factors_to_consider)
        population = GeneticAlgorithm.replace_worst_ranked(population, offsprings)    
      end
      best_chromosome = GeneticAlgorithm.select_best_chromosome(population)
    end
      
    #selection mimic the process of natural selection to select the individuals that have better fitness values.
    #process:
    # 1. fitness is called to evaluate the utility value of individual
    # 2. the population is sorted by descending order of fitness value
    # 3. the fitness value is normalized
    # 4. a random number R is chosen. R is between 0 and the accumulated normalized value (it is normalized value plus the normalized values of the chromosome prior it)
    #    greater than R
    # 5. the selected individual is the first one whose accumulated normalized value (it is normalized value plus the normalized values of the chromosome prior it)
    #    greater than R
    # 6. repeat 4 and 5 for 2/3 times the population size
  
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
      (population.size * 2/3).times do
        breed_population << select_random_individual(population, accumulated_fitness)
      end
      breed_population
    end
     
    # reproduction calls on Chromosome.reproduce to produce the offspring generation
    def self.reproduction(breed_population)
      offspring = []
      0.upto(breed_population.size/2 - 1) do |i|
        offspring << Chromosome.reproduce(breed_population[2*i], breed_population[2*i+1])
      end
      offspring
    end
      
    # mutate_all_population will call Chromosome.mutate on each chromosome in the population  
    def self.mutate_all_population(population)
      mutated_population = []
      population.each do |chromosome|
        mutated_population << Chromosome.mutate(chromosome)
      end
      mutated_population
    end
       
    # select the best chromosome in the population
    def self.select_best_chromosome(population)
      best_chromosome = population[0]
      population.each do |chromosome|
        best_chromosome = chromosome if chromosome.fitness > best_chromosome.fitness
      end
      best_chromosome
    end
    
    # replace_worst_ranked replaces the worst ranked population with its offsprings
    def self.replace_worst_ranked(population, offsprings)
      size = offsprings.size
      population = population[0..((-1*size)-1)] + offsprings
    end
           
    private unless Rails.env == 'test'
    
    def self.select_random_inidividual(population, accumulated_fitness)
      select_random_target = accumulated_fitness * rand
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
    
    def initialize(meeting_solution)
      @meeting_solution = meeting_solution
      @normalized_fitness = 0
    end
    
    def self.set_factors_to_consider(factors_to_consider)
      @@factors_to_consider = factors_to_consider
    end
       
    # fitness is basically a utility/heuristic value function that evaluate how good a particular solution is
    def fitness
      return @fitness if @fitness
      # else calculate and save to @fitness, TO BE IMPLEMENTED
      return @fitness
    end
    
    def self.mutate(chromosome)
      # add more stuff such as double mutation, inversion, translocation of two snippets, simulated annealing mutation rates, etc
      if chromosome.normalized_fitness && rand < ((1 - chromosome.normalized_fitness) * 0.3)
        which_mutation = rand(100)
        case which_mutation
        when 0..33
          indexes = Chromosome.pick_two_random_indexes(chromosome)
          Chromosome.chromosomal_inversion(chromosome, indexes[0], indexes[1])
        when 33..66
          index = rand(chromosome.length - 1)
          Chromosome.reverse_two_adjacent_sequences(chromosome, index)
        else
          index = rand(chromosome.length)
          Chromosome.point_mutation(chromosome, index)
        end
        @fitness = nil # need to recalculate fitness value when fitness method is called
      end      
    end
    
    # Produces only ONE child chromosome
    def self.reproduce(parent1, parent2, double_crossover_probability)
      if rand < double_crossover_probability
        indexes = Chromosome.pick_two_random_indexes(parent1)        
        Chromosome.double_crossover(parent1, parent2, indexes[0], indexes[1])
      else
        splice_index = rand(parent1.length - 2) + 1
        Chromosome.single_crossover(parent1, parent2, splice_index)
      end
    end
    
    # seed produces an individual solution (chromosome) for the initial population
    def self.seed
      meeting_solution =  Chromosome.create_meeting_solution # original code moved to method create_meeting_solution
      Chromosome.new(meeting_solution)
    end
    

    def [](index)
      self.meeting_solution[index]
    end

    def []=(index, assignment)
      self.meeting_solution[index] = assignment
    end

    def <=>(other)
      self.meeting_solution <=> other.meeting_solution
    end

    def length
      self.meeting_solution.length
    end

    
    private unless Rails.env == 'test'
    
    def self.create_meeting_solution
      total_admits = @@factors_to_consider[:total_admits]
      attending_admits = @@factors_to_consider[:attending_admits]
      total_number_of_meetings = @@factors_to_consider[:total_number_of_meetings]
      
      meeting_solution = Array.new(total_number_of_meetings)
      number_of_spots_per_student = (total_number_of_meetings / attending_admits).floor - 1 # should it be attending_admits?
      admit_ids = attending_admits.collect{ |admit| [admit.id] * number_of_spots_per_student }.flatten.shuffle
      
      admit_ids.each do |id|
        index = rand(total_number_of_meetings)
        while meeting_solution(index) # if the spot is occupied, we find a new spot
          index = rand(total_number_of_meetings)
        end
        meeting_solution[index] = id
      end
      meeting_solution
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
      meeting_solution = chromosome.meeting_solution
      partially_inverted_meeting_solution = meeting_solution[index1..index2].reverse
      meeting_soltuon = meeting_solution[0...index1] + partially_inverted_meeting_solution + meeting_solution[index2+1..-1]
      chromosome.meeting_solution = meeting_solution
    end
    
    def self.point_mutation(chromosome, index)
      attending_admits = @@factors_to_consider[:attending_admits]
      admit_id = attending_admits.collect{ |admit| admit.id }.shuffle.fetch(0)
      meeting_solution = chromosome.meeting_solution
      meeting_solution[index] = admit_id
      chromosome.meeting_solution = meeting_solution
    end

    # Abstracted methods for easier stubbing in Rspec tests
    def self.pick_two_random_indexes(sample_chromosome)
      index1 = index2 = rand(sample_chromosome.length - 3) + 1
      while splice_index2 <= splice_index1
        splice_index2 = rand(sample_chromosome.length - 2) + 1
      end
      [index1, index2]
    end
    
  end
  
end
