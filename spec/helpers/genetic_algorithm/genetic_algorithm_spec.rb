#require 'spec_helper'

#describe MeetingsScheduler::GeneticAlgorithm do

=begin
  describe MeetingsScheduler::GeneticAlgorithm do
    describe "class method: run" do
    end

    describe "class method: selection" do
      it "should select a breed population given a population of chromosomes" do
        meeting_solution = mock("meeting_solution")
        #@factors_to_consider = create_valid_factors_hash
        #@solution_string = create_valid_solution_string(@factors_to_consider)
        #@chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
        @chromosome1 = mock("chromosome1")
        @chromosome2 = mock("chromosome2")
        @chromosome3 = mock("chromosome3")
        @chromosome4 = mock("chromosome4")

        @chromosome1.stub(:fitness).and_return(50)
        @chromosome2.stub(:fitness).and_return(55)
        @chromosome3.stub(:fitness).and_return(40)
        @chromosome4.stub(:fitness).and_return(35)

        @chromosome1.stub(:normalized_fitness=)
        @chromosome2.stub(:normalized_fitness=)
        @chromosome3.stub(:normalized_fitness=)
        @chromosome4.stub(:normalized_fitness=)

        @chromosome1.stub(:normalized_fitness).and_return(0.75)
        @chromosome2.stub(:normalized_fitness).and_return(1)
        @chromosome3.stub(:normalized_fitness).and_return(0.25)
        @chromosome4.stub(:normalized_fitness).and_return(0)

        population = [@chromosome1, @chromosome2, @chromosome3, @chromosome4]
        MeetingsScheduler::GeneticAlgorithm.stub!(:select_random_individual).and_return(@chromosome3, @chromosome1)
        breed_population = MeetingsScheduler::GeneticAlgorithm.selection(population)
        breed_population.count.should == 2
        breed_population.should == [@chromosome3, @chromosome1]
      end
    end

    describe "class method: reproduction" do
      it "should produce a offspring population given a parent population of chromosomes" do

        offspring_chromosome1 = mock("mutated_chromosome1", :fitness => 45)
        offspring_chromosome2 = mock("mutated_chromosome2", :fitness => 68)
        offspring_chromosome3 = mock("mutated_chromosome3", :fitness => 79)
        MeetingsScheduler::Chromosome.stub!(:reproduce).and_return(offspring_chromosome1, offspring_chromosome2, offspring_chromosome3)

        chromosome1 = mock("chromosome1", :fitness => 50)
        chromosome2 = mock("chromosome2", :fitness => 55)
        chromosome3 = mock("chromosome3", :fitness => 40)
        breed_population = [chromosome1, chromosome2, chromosome3]

        offsprings = MeetingsScheduler::GeneticAlgorithm.reproduction(breed_population)
        offsprings.should == [offspring_chromosome1]
      end
    end

    describe "class method: mutate_all_population" do
      it "should return a newly mutated population given a population of chromosomes" do
        mutated_chromosome1 = mock("mutated_chromosome1", :fitness => 45)
        mutated_chromosome2 = mock("mutated_chromosome2", :fitness => 68)
        mutated_chromosome3 = mock("mutated_chromosome3", :fitness => 79)
        MeetingsScheduler::Chromosome.stub!(:mutate).and_return(mutated_chromosome1, mutated_chromosome2, mutated_chromosome3)

        chromosome1 = mock("chromosome1", :fitness => 50)
        chromosome2 = mock("chromosome2", :fitness => 55)
        chromosome3 = mock("chromosome3", :fitness => 40)
        population = [chromosome1, chromosome2, chromosome3]

        mutated_population = MeetingsScheduler::GeneticAlgorithm.mutate_all_population(population)
        mutated_population.should == [mutated_chromosome1, mutated_chromosome2, mutated_chromosome3]
      end
    end

    describe "class method: select_best_chromosome" do
      it "should select the chromosome with fitness 55 when given a population of three chromosomes with fitness 50, 55, and 40" do
        chromosome1 = mock("chromosome1", :fitness => 50)
        chromosome2 = mock("chromosome2", :fitness => 55)
        chromosome3 = mock("chromosome3", :fitness => 40)

        population = [chromosome1, chromosome2, chromosome3]
        best_chromosome = MeetingsScheduler::GeneticAlgorithm.select_best_chromosome(population)
        best_chromosome.fitness.should == 55
      end
    end

    describe "class method: replace_worst_ranked" do
      it "should replaces the less fit chromosomes in the population by the offspring chromosomes" do
        chromosome1 = mock("chromosome1", :fitness => 50)
        chromosome2 = mock("chromosome2", :fitness => 55)
        chromosome3 = mock("chromosome3", :fitness => 40)
        chromosome4 = mock("chromosome4", :fitness => 35)

        offspring_chromosome1 = mock("offspring_chromosome1", :fitness => 60)
        offspring_chromosome2 = mock("offspring_chromosome2", :fitness => 36)

        population = [chromosome1, chromosome2, chromosome3, chromosome4]
        offsprings = [offspring_chromosome1, offspring_chromosome2]
        new_population = MeetingsScheduler::GeneticAlgorithm.replace_worst_ranked(population, offsprings)

        new_population.should == [chromosome2, chromosome1, offspring_chromosome1, offspring_chromosome2]
      end
    end

    describe "class method: select_random_inidividual" do
      it "should return a randomly selected chromosome given a population of chromosomes" do
        chromosome1 = mock("chromosome1", :fitness => 50, :normalized_fitness => 0.75)
        chromosome2 = mock("chromosome2", :fitness => 55, :normalized_fitness => 1)
        chromosome3 = mock("chromosome3", :fitness => 40, :normalized_fitness => 0.25)
        chromosome4 = mock("chromosome4", :fitness => 35, :normalized_fitness => 0)
        population = [chromosome1, chromosome2, chromosome3, chromosome4]
        accumulated_normalized_fitness = 2
        MeetingsScheduler::GeneticAlgorithm.stub!(:rand).and_return(0.687901)

        chromosome = MeetingsScheduler::GeneticAlgorithm.select_random_individual(population, accumulated_normalized_fitness)
        chromosome.should == chromosome2
      end
    end
  end
=end
#end
