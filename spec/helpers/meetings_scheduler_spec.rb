require 'spec_helper'

describe MeetingsScheduler do
  describe MeetingsScheduler::Scheduler do
    
  end

  describe MeetingsScheduler::GeneticAlgorithm do
    describe "class method: run" do
    end
  
    describe "class method: selection" do
      it "should select a breed population given a population of chromosomes" do
        meeting_solution = mock("meeting_solution")
        @chromosome1 = MeetingsScheduler::Chromosome.new(meeting_solution)
        @chromosome2 = MeetingsScheduler::Chromosome.new(meeting_solution)
        @chromosome3 = MeetingsScheduler::Chromosome.new(meeting_solution)
        @chromosome4 = MeetingsScheduler::Chromosome.new(meeting_solution)
        
        @chromosome1.stub(:fitness).and_return(50)
        @chromosome2.stub(:fitness).and_return(55)
        @chromosome3.stub(:fitness).and_return(40)
        @chromosome4.stub(:fitness).and_return(35)
        
        
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
   
  describe MeetingsScheduler::Chromosome do
    describe 'Solutions' do
      before(:each) do
        @chromosome = MeetingsScheduler::Chromosome.new([1,2,3])
      end
      
      it 'has a encoding/representation of a solution' do
        @chromosome.should respond_to(:meeting_solution)
        @chromosome.should respond_to(:meeting_solution=)
      end
      
      it 'is accessible in an array-like fashion' do
        @chromosome.should respond_to(:[])
        @chromosome.should respond_to(:[]=)
      end
      
      it 'has a normalized fitness value for purposes of GA' do
        @chromosome.should respond_to(:normalized_fitness)
        @chromosome.should respond_to(:normalized_fitness=)
      end

      it 'has a description of solution fitness' do @chromosome.should respond_to(:fitness) end

      it 'has an unmutable length' do @chromosome.should respond_to(:length) end

    end
    
    describe 'When seeding a new chromosome' do
      before(:each) do
        @faculties = 3.times.collect { |n| create_valid!(Faculty, :id => n) }
        @admits= 2.times.collect { |n| create_valid!(Faculty, :id => n) }

        @faculties.each { |f| f.stub!().and_return()}
        @admits.each { |a| a.stub!().and_return()}
      end

      it 'should corrrectly determine the \'length\' of the chromosome' do
        # set up faculty models and stuff correctly
        MeetingsScheduler::Chromosome.chromosome_length.should == xxx        
      end

      it 'the seed method should return a new chromosome, with the correct length' do
        # set up faculty models and stuff correctly
        @chromosome = MeetingsScheduler::Chromosome.seed
        @chromosome.class.should == MeetingsScheduler::Chromosome
        @chromosome.length.should == xxx
      end

      it 'should add into the solution only students that plan to attend Visit Day' do

      end
    end

    describe 'When reproducing to form children' do
      before(:each) do
        @parent1 = MeetingsScheduler::Chromosome.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        @parent2 = MeetingsScheduler::Chromosome.new(%w[a b c d e f g h i j])
      end
      
      describe 'When performing single crossover' do
        before(:each) do
          splice_index = 3
          @child = MeetingsScheduler::Chromosome.single_crossover(@parent1, @parent2, splice_index)
        end

        it 'should return a chromosome' do @child.class.should == MeetingsScheduler::Chromosome end
        it 'should single-swap correctly' do @child.should == MeetingsScheduler::Chromosome.new([1, 2, 3] + %w[d e f g h i j]) end
      end
      
      describe 'When performing double crossover' do
        before(:each) do
          splice_index1, splice_index2 = 3, 8
          @child = MeetingsScheduler::Chromosome.double_crossover(@parent1, @parent2, splice_index1, splice_index2)
        end

        it 'should return a chromosome' do @child.class.should == MeetingsScheduler::Chromosome end
        it 'should double-swap correctly' do @child.should == MeetingsScheduler::Chromosome.new([1, 2, 3] + %w[d e f g h] + [9, 10]) end
      end
    end
    
    describe 'When mutating chromosomes' do
      before(:each) do
        @chromosome = MeetingsScheduler::Chromosome.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      end

      describe 'When performing a point mutation' do
        before(:each) do
          index = 4
          Admit.stub!(:attending_admits).and_return [create_valid!(Admit, :id => 1)]
          MeetingsScheduler::Chromosome.point_mutation(@chromosome, index)
        end
        
        it 'should have same length after mutation' do @chromosome.length.should == 10 end
        it 'should mutate correctly' do @chromosome.should == MeetingsScheduler::Chromosome.new([1, 2, 3, 4, 1, 6, 7, 8, 9, 10]) end
      end

      describe 'When performing a chromosomal inversion' do
        before(:each) do
          index1, index2 = 4, 7
          MeetingsScheduler::Chromosome.chromosomal_inversion(@chromosome, index1, index2)
        end

        it 'should have same length after mutation' do @chromosome.length.should == 10 end
        it 'should invert chromosome correctly' do @chromosome.should == MeetingsScheduler::Chromosome.new([1, 2, 3, 4, 8, 7, 6, 5, 9, 10]) end
      end

     
      describe 'When performing a reverse on two adjacent sequences' do
        before(:each) do
          index = 5
          MeetingsScheduler::Chromosome.reverse_two_adjacent_sequences(@chromosome, index)
        end

        it 'should have same length after mutation' do @chromosome.length.should == 10 end
        it 'should invert chromosome correctly' do @chromosome.should == MeetingsScheduler::Chromosome.new([1, 2, 3, 4, 5, 7, 6, 8, 9, 10]) end
      end
      
    end
    
  end
end
