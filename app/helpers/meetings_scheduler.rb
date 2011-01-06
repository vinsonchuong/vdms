module MeetingsScheduler
  
  class GeneticAlgorithm
    attr_accessor :population
    @population_size = 0
    @max_generation = 0
    
    # originally the initialize function in the gem
    def self.configuration(population_size, max_generation)
      @population_size = population_size
      @max_generation = max_generation
    end
    
    def self.run
      GeneticAlgorithm.initialization
      @max_generation.times do
        parents = GeneticAlgorithm.selection
        offsprings = GeneticAlgorithm.reproduction(parents)
        GeneticAlgorithm.replace_worst_ranked (offsprings)
      end
      select_best_chromosome
    end
  
    def self.initailization
      @current_generation = 0
      @population = []
      @population_size.times do 
        population << Chromosome.seed
      end
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
    def self.selection
      @population.sort! { |a, b| b.fitness <=> a.fitness }
      
      best_fitness = @population[0].fitness
      least_fitness = @population.last.fitness
      accumulated_fitness = 0
      
      if (best_fitness - least_fitness) > 0
        @population.each do |chromosome|
          chromosome.normalized_fitness = (chromosome.fitness - least_fitness) / (best_fitness - least_fitness)
          accumulated_fitness += chromosome.normalized_fitness
        end
      else
        @population.each {|chromosome| chromosome.normalized_fitness = 1 }
      end 
      
      breed_population = []
      (@population_size * 2/3).times do
        breed_population << select_random_individual(accumulated_fitness)
      end
      breed_population
    end
  
    
    # The reproduction method will call the chromosome.mutate method with each member of the population.
    # and then generate the offspring population
    def self.reproduction(breed_population)
      offspring = []
      
      0.upto(breed_population.length/2 - 1) do |i|
        offspring << reproduce(breed_population[2*i], breed_population[2*i+1])
      end
      
      @population.each do |chromosome|
        Chromosome.mutate(chromosome)
      end
      offspring
    end
    
    # select the best chromosome in the population
    def self.select_best_chromosome
      best_chromosome = @population [0]
      @population.each do |chromosome|
        best_chromosome = chromosome if chromosome.fitness > best_chromosome.fitness
      end
      best_chromosome
    end
    
    def self.replace_worst_ranked(offsprings)
      size = offsprings.length
      @population = @population[0..((-1*size)-1)] + offsprings
    end
    
    private
    
    def self.select_random_inidividual(accumulated_fitness)
      select_random_target = accumulated_fitness * rand
      local_acum = 0
      @population.each do |chromosome|
        local_acum += chromosome.normalized_fitness
        return chromosome if local_acum >= select_random_target
      end
    end
    
  end
  
  class Chromosome
    attr_accessor :data
    attr_accessor :normalized_fitness
    
    def initialize(data)
      @data = data
    end
  
    
    # fitness is basically a utility/heuristic value function that evaluate how good a particular solution is
    def fitness
    end
  
    def self.mutate(chromosome)
    end
  
    def self.reproduce(parent1, parent2)
    end
    
    # seed produces an individual solution (chromosome) for the initial population
    def self.seed
    end
  
  end
    
end