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
        @population = Scheduler.create_population(factors_to_consider)
        @total_generations = total_generations
        @population_size = population_size
      end
      
      def make_meetings()
        best_chromosome = GeneticAlgorithm.run(@population, @total_generations)
        Scheduler.create_meetings!(best_chromosome)
      end
      
      private unless Rails.env == 'test'
      
      def self.create_meetings!(best_chromosome)
        ## to be implemented
      end
      
      def self.create_population(factors_to_consider)
        population = []
        @population_size.times do
          population << Chromosome.seed(factors_to_consider)
        end
        population
      end
               
  end
  
  class GeneticAlgorithm
    # run is the main execution of the algorithm. Calling run will theoritically output the best solution available after 
    # total_generations 
    def self.run(population, total_generations)
      total_generations.times do
        parents = GeneticAlgorithm.selection(population)
        offsprings = GeneticAlgorithm.reproduction(parents)
        population = GeneticAlgorithm.mutate_all_population(population)
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
    
    attr_accessor :data
    attr_accessor :normalized_fitness
    
    def initialize(data)
      @data = data
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
        @fitness = nil
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
    def self.seed#(factors_to_consider)
      #total_admits = factors_to_consider[:total_admits]
      #attending_admits = factors_to_consider[:attending_admits]
      #number_of_spots_per_student = factors_to_consider[:number_of_spots_per_student]
      
      total_admits = Admit.count
      chromosome = Array.new(Chromosome.chromosome_length)
      number_of_spots_per_student = (chromosome_length / total_admits).floor - 1
      admit_ids = Admit.attending_admits.collect{ |admit| [admit.id]*number_of_spots_per_student }.flatten.shuffle
      
      admit_ids.each do |id|
        i = rand(chromosome.length)
        while array[i]
          i = rand(chromosome.length)
        end
        array[i] = id
      end
      return Chromosome.new(chromosome)
    end
    

    def [](index)
      self.data[index]
    end

    def []=(index, assignment)
      self.data[index] = assignment
    end

    def <=>(other)
      self.data <=> other.data
    end

    def length
      self.data.length
    end

    
    private unless Rails.env == 'test'

    def self.chromosome_length
      Faculty.all.inject { |count, f| count + (f.schedule.count * f.max_students_per_meeting) }
    end


    # Methods for generating children
    
    def self.single_crossover(parent1, parent2, splice_index)
      return Chromosome.new(parent1[0...splice_index] + parent2[splice_index..-1])
    end
    
    def self.double_crossover(parent1, parent2, splice_index1, splice_index2)
      return Chromosome.new(parent1[0...splice_index1] +
                            parent2[splice_index1...splice_index2] +
                            parent1[splice_index2..-1])
    end
    
    
    # Methods for generating mutations
    
    def self.reverse_two_adjacent_sequences(chromosome, index)
      Chromosome.chromosomal_inversion(chromosome, index, index+1)
    end
    
    def self.chromosomal_inversion(chromosome, index1, index2)
      data = chromosome.data
      inversion = data[index1..index2].reverse
      data = data[0...index1] + inversion + data[index2+1..-1]
      chromosome.data = data
    end
    
    def self.point_mutation(chromosome, index)
      admit = Admit.attending_admits.collect{ |admit| admit.id }.shuffle.fetch(0)
      data = chromosome.data
      data[index] = admit
      chromosome.data = data
    end

    # Abstracted methods for easier stubbing in Rspec tests
    def self.pick_two_random_indexes(sample_chromosome)
      index1 = index2 = rand(sample_chromosome.length - 3) + 1
      while splice_index2 <= splice_index1
        splice_index2 = rand(sample_chromosome.length - 2) + 1
      end
      return [index1, index2]
    end
    
  end
  
end
