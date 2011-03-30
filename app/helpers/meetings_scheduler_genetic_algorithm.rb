require 'meetings_scheduler_chromosome'
require 'meetings_scheduler_nucleotide'

module MeetingsScheduler
  module GeneticAlgorithm

    def self.create_meetings_from_chromosome!(best_chromosome)
      puts "Initializing all Meeting objects for ATTENDING faculties..."
      @all_meetings = initialize_all_meetings
      fill_up_meetings_with_best_chromosome!(best_chromosome)
      save_all_created_meetings_to_database!
    end

    # For debugging purposes
    def self.all_meetings
      @all_meetings
    end


    private unless Rails.env == 'test'

    # ROUNDABOUT VALIDATIONS HACK TO BYPASS STRICT ONE-ON-ONE REQUIREMENT
    def self.save_all_created_meetings_to_database!
      puts "Saving all new Meetings to database - this may take a while..."
      @all_meetings.each_with_index do |m, i|
        m.save!
        puts "##{i} finished"
      end
      puts "Finished."
    end

    def self.initialize_all_meetings
      @all_meetings = Faculty.all.collect do |faculty|
        faculty.available_times.select(&:available).collect{ |available_time| faculty.meetings.new(:time => available_time.begin,
                                                                                                   :room => faculty.room_for(available_time.begin))}
      end
      @all_meetings.flatten!
    end

    def self.fill_up_meetings_with_best_chromosome!(best_chromosome)
      best_chromosome.reduced_meeting_solution.each do |nucleotide|
        fill_up_meeting_with_nucleotide!(nucleotide) if nucleotide.is_meeting_possible?
      end
    end

    def self.fill_up_meeting_with_nucleotide!(nucleotide)
      meeting = find_meeting_object_by_nucleotide(nucleotide)
      meeting.admits << Admit.find(nucleotide.admit_id)
    end

    def self.find_meeting_object_by_nucleotide(nucleotide)
      faculty, schedule, admit = nucleotide.extract
      @all_meetings.find{ |m| m.faculty_id == faculty[:id] and m.time == schedule[:time_slot].begin }
    end



    class GA

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
        total_generations.times do |generation_num|
          puts "At generation #{generation_num+1} of #{total_generations}"
          parents = GeneticAlgorithm.selection(population)
          offsprings = GeneticAlgorithm.reproduction(parents)
          population = GeneticAlgorithm.mutate_all_population(population)
          population = GeneticAlgorithm.replace_worst_ranked(population, offsprings)
        end
        puts "GA finished."
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
  end
end

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
#
#fitness_scores_table: a hash that contains all the different scores awarded to model a chromosome's fitness
#                     {
#                      :is_meeting_possible_score,
#                      :is_meeting_possible_penalty,
#                      :faculty_ranking_weight_score,
#                      :faculty_ranking_default,
#                      :admit_ranking_weight_score,
#                      :admit_ranking_default,
#                      :area_match_score,
#                      :area_match_default,
#                      :one_on_one_score,
#                      :one_on_one_penalty,
#                      :one_on_one_default,
#                      :mandatory_score,
#                      :mandatory_default,
#                      :consecutive_timeslots_default,
#                      :consecutive_timeslots_weight_score
#                    }
#
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
