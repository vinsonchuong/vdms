require 'spec_helper'

describe MeetingsScheduler do

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
   
  describe MeetingsScheduler::Chromosome do
    before(:each) do
      @factors_to_consider = create_valid_factors_hash
      MeetingsScheduler::Chromosome.set_factors_to_consider(@factors_to_consider)      
    end
    
    describe "Instance Attributes:" do
      before(:each) do 
        @solution_string = create_valid_solution_string(@factors_to_consider)
        @chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
      end
          
      describe "meeting_solution" do
        it "should respond to meeting_solution" do
          @chromosome.should respond_to(:meeting_solution)
        end
        
        it "should respond to meeting_solution=" do
          @chromosome.should respond_to(:meeting_solution=)
        end
        
        it 'should return a meeting_solution, which is an array of nucleotides' do  
          @chromosome.meeting_solution.class.should == Array     
          @chromosome.meeting_solution.each do |nucleotide|
            nucleotide.class.should == MeetingsScheduler::Nucleotide
          end
        end
      end
      
      describe "normalized_fitness" do
        it "should respond to normalized_fitness" do
          @chromosome.should respond_to(:normalized_fitness)
        end
        
        it "should respond to normalized_fitness=" do
          @chromosome.should respond_to(:normalized_fitness=)
        end
      end
    end
        
    describe "Instance Methods:" do
      before(:each) do 
        @solution_string = create_valid_solution_string(@factors_to_consider)
        @chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
      end
      
      describe "solution_string" do
        it "should respond to solution_string" do
          @chromosome.should respond_to(:solution_string)
        end
        
        it 'should return an Array encoding a solution of admit_id\'s' do  
          @chromosome.solution_string.should == @solution_string
        end
      end
      
      describe "[]" do
        it "should respond to []" do
          @chromosome.should respond_to(:[])
        end
       
        it 'should be able to use chromosome as an array and the return values should match that of the input solutiong_string array' do  
          @solution_string.each_with_index do |admit_id, index|
            @chromosome[index].should == admit_id
          end
        end
      end
    
      describe "length" do
        it "should respond to length" do
          @chromosome.should respond_to(:length)
        end
        
        it 'should return the number of nucleotides in the chromosome and the return value should match the total_number_of_seats available' do
          @chromosome.length.should == @factors_to_consider[:total_number_of_seats]
        end
      end
    
      describe '<=> / ==' do
        it "should respond to ==" do
          @chromosome.should respond_to(:==)
        end
        
        it 'should be able to compare the solution_strings (array of admit_id\'s) of each chromosome' do
          @copy_of_solution_string = Array.new(@solution_string)
            
          @chromosome2 = MeetingsScheduler::Chromosome.new(@solution_string)    
          @chromosome.==(@chromosome2).should == true
          
          #make sure they differ by the first admit_id
          @solution_string[0] = 1
          @copy_of_solution_string[0] = 0
          @chromosome2 = MeetingsScheduler::Chromosome.new(@solution_string)
          @chromosome3 = MeetingsScheduler::Chromosome.new(@copy_of_solution_string)

          @chromosome2.==(@chromosome3).should == false
          
        end
      end
    
      describe 'instance method: fitness' do
        it 'should respond to fitness' do
          @chromosome.should respond_to(:fitness)
        end

        it 'should first remove duplicates before evaluating fitness' do
          MeetingsScheduler::Chromosome.stub!(:remove_duplicates).and_return(@chromosome.meeting_solution)
          MeetingsScheduler::Chromosome.stub!(:fitness_of_nucleotide).and_return(0)
          MeetingsScheduler::Chromosome.should_receive(:remove_duplicates).once
          @chromosome.fitness
        end

        it 'should return the sum of the fitness scores of each nucleotide, nil or not' do          
          @fitness = 500
          MeetingsScheduler::Chromosome.stub!(:remove_duplicates).and_return(@chromosome.meeting_solution)
          MeetingsScheduler::Chromosome.stub!(:fitness_of_nucleotide).and_return(@fitness)
          MeetingsScheduler::Chromosome.should_receive(:fitness_of_nucleotide).exactly(@solution_string.count).times
          @chromosome.fitness.should == @solution_string.count * @fitness
        end
      end
    end

    describe "Class Methods:" do  
        
      describe 'mutate' do
        before(:each) do 
          @solution_string = create_valid_solution_string(@factors_to_consider)
          @chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
          @chromosomal_inversion_probability = @factors_to_consider[:chromosomal_inversion_probability]
          @point_mutation_probability = @factors_to_consider[:point_mutation_probability]
          MeetingsScheduler::Chromosome.stub!(:ok_to_mutate).and_return true
        end
        
        
        describe "chromosomal inversion" do
          before(:each) do
            @rand_probability_for_chromosomal_inversion = rand()
          
            while @rand_probability_for_chromosomal_inversion > @chromosomal_inversion_probability
              @rand_probability_for_chromosomal_inversion = rand()
            end
            
            @rand_index1 = rand(@chromosome.length - 5) + 1
            @rand_index2 = rand(@chromosome.length - 5) + 1
          
            while @rand_index2 <= @rand_index1+1
              @rand_index2 = rand(@chromosome.length - 2) + 1
            end
            
          end

          it "must call :chromosomal_inversion once" do
            MeetingsScheduler::Chromosome.stub!(:rand).and_return(@rand_probability_for_chromosomal_inversion)
            MeetingsScheduler::Chromosome.stub!(:pick_two_random_indexes).and_return [@rand_index1, @rand_index2]
            MeetingsScheduler::Chromosome.should_receive(:chromosomal_inversion).once.with(@chromosome, @rand_index1, @rand_index2)
            MeetingsScheduler::Chromosome.mutate(@chromosome)
          end

          it 'should choose to invert chromosome #{@chromosomal_inversion_probability*100} % of the time and return an newly inverted chromosome' do    
            MeetingsScheduler::Chromosome.stub!(:rand).and_return(@rand_probability_for_chromosomal_inversion)  
            MeetingsScheduler::Chromosome.stub!(:pick_two_random_indexes).and_return [@rand_index1, @rand_index2]
            @new_chromosome = MeetingsScheduler::Chromosome.mutate(@chromosome)
        
            @new_chromosome.solution_string.should == @chromosome[0...@rand_index1] + @chromosome[@rand_index1..@rand_index2].reverse + @chromosome[@rand_index2+1..-1] 
            @new_chromosome.length.should == @chromosome.length
          end
        end
        
        describe "chromosomal point mutation" do
          before(:each) do
            @rand_probability_for_point_mutation_probability = rand() 
            while @rand_probability_for_point_mutation_probability > @point_mutation_probability
              @rand_probability_for_point_mutation_probability = rand() 
            end
            @rand_probability_for_point_mutation_probability = @rand_probability_for_point_mutation_probability + @chromosomal_inversion_probability
            @rand_index = rand(@chromosome.length)
          end

          it "must call :point_mutation once" do
            MeetingsScheduler::Chromosome.stub!(:rand).and_return(@rand_probability_for_point_mutation_probability, @rand_index)
            MeetingsScheduler::Chromosome.should_receive(:point_mutation).once.with(@chromosome, @rand_index)
            MeetingsScheduler::Chromosome.mutate(@chromosome)
          end

          it 'should choose point mutation #{@point_mutation_probability*100} % of the time and return a newly point mutated chromosome' do
            MeetingsScheduler::Chromosome.stub!(:rand).and_return(@rand_probability_for_point_mutation_probability, @rand_index)
            @new_chromosome = MeetingsScheduler::Chromosome.mutate(@chromosome)  
            @new_chromosome.solution_string.each_with_index do |admit_id, index|
              if index != @rand_index
                admit_id.should == @solution_string[index]
              else
                admit_id.class.should == Fixnum
              end
            end
            @new_chromosome.length.should == @chromosome.length
          end
        end
        
        describe "chromosomal reverse 2 adjacent sequences" do
          before(:each) do
            @rand_probability_for_reverse_2_adjacent_sequences = 1
            @rand_index = rand(@chromosome.length-1)
          end
          
          it "must call :reverse_two_adjacent_sequences once" do
            MeetingsScheduler::Chromosome.stub!(:rand).and_return(@rand_probability_for_reverse_2_adjacent_sequences, @rand_index)
            MeetingsScheduler::Chromosome.should_receive(:reverse_two_adjacent_sequences).once.with(@chromosome, @rand_index)
            MeetingsScheduler::Chromosome.mutate(@chromosome)
          end
          
          it "should reverse 2 adjacent sequences as default and return a newly 2 adjacent sequences reversed chromosome" do
            MeetingsScheduler::Chromosome.stub!(:rand).and_return(@rand_probability_for_reverse_2_adjacent_sequences, @rand_index)
            @new_chromosome = MeetingsScheduler::Chromosome.mutate(@chromosome)
            @new_chromosome.solution_string.should == @chromosome[0...@rand_index] + @chromosome[@rand_index..@rand_index+1].reverse + @chromosome[@rand_index+2..-1]
            @new_chromosome.length.should == @chromosome.length
          end
        end
      end

      describe 'mutate helper methods' do
        before(:each) do
          @solution_string = create_valid_solution_string(@factors_to_consider)
          @chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
          @chromosome_length = @chromosome.length
        end

        describe 'class method: reverse_two_adjacent_sequences' do                 
          it 'should return a new chromosome with two adjacent sequences reversed, given a chromosome where the indicated index is randomly chosen' do
            @index = rand(@chromosome_length-1)
            @mutant = MeetingsScheduler::Chromosome.reverse_two_adjacent_sequences(@chromosome, @index)
            @mutant.class.should == MeetingsScheduler::Chromosome
            @mutant.solution_string.should == (@chromosome[0...@index] + @chromosome[@index..@index+1].reverse + @chromosome[@index+2..-1])
          end
          
          it 'should return a new chromosome with two adjacent sequences reversed, given a chromosome where the indicated index is at 0' do
            @index = 0
            @mutant = MeetingsScheduler::Chromosome.reverse_two_adjacent_sequences(@chromosome, @index)
            @mutant.class.should == MeetingsScheduler::Chromosome
            @mutant.solution_string.should == (@chromosome[0...@index] + @chromosome[@index..@index+1].reverse + @chromosome[@index+2..-1])
          end
          
          it 'should return a new chromosome with two adjacent sequences reversed, given a chromosome where the indicated index is at two nucleotides before the end of the chromosome' do
            @index = @chromosome_length-2
            @mutant = MeetingsScheduler::Chromosome.reverse_two_adjacent_sequences(@chromosome, @index)
            @mutant.class.should == MeetingsScheduler::Chromosome
            @mutant.solution_string.should == (@chromosome[0...@index] + @chromosome[@index..@index+1].reverse + @chromosome[@index+2..-1])
          end
        end    

        describe 'class method: chromosomal_inversion' do
          it 'should return a new chromosome with proper inversion, given a chromosome where the indexes are chosen at random' do
            @index1, @index2 = MeetingsScheduler::Chromosome.pick_two_random_indexes(@chromosome)
            @mutant = MeetingsScheduler::Chromosome.chromosomal_inversion(@chromosome, @index1, @index2)
            @mutant.class.should == MeetingsScheduler::Chromosome
            @mutant.solution_string.should == @chromosome[0...@index1] + @chromosome[@index1..@index2].reverse + @chromosome[@index2+1..-1]
          end
          
          it 'should return a new chromosome with proper inversion, given a chromosome with front corner indexes' do
            @index1 = 0  
            @index2 = 4
            @mutant = MeetingsScheduler::Chromosome.chromosomal_inversion(@chromosome, @index1, @index2)
            @mutant.class.should == MeetingsScheduler::Chromosome
            @mutant.solution_string.should == @chromosome[0...@index1] + @chromosome[@index1..@index2].reverse + @chromosome[@index2+1..-1]
          end
          
          it 'should return a new chromosome with proper inversion, given a chromosome with back corner indexes' do
            @index1 = @chromosome.length - 4  
            @index2 = @chromosome.length - 1
            @mutant = MeetingsScheduler::Chromosome.chromosomal_inversion(@chromosome, @index1, @index2)
            @mutant.class.should == MeetingsScheduler::Chromosome
            @mutant.solution_string.should == @chromosome[0...@index1] + @chromosome[@index1..@index2].reverse + @chromosome[@index2+1..-1]
          end        
        end
        
        describe 'class method: point_mutation' do
          it 'should return a new chromosome with proper mutation, given a chromosome' do
            @index = rand(@length)
            @mutant = MeetingsScheduler::Chromosome.point_mutation(@chromosome, @index)
            @mutant.class.should == MeetingsScheduler::Chromosome
            @factors_to_consider[:attending_admits].keys.include?(@mutant[@index]).should == true
            (@mutant[0...@index]+@mutant[@index+1..-1]).should == @chromosome[0...@index]+@chromosome[@index+1..-1]
          end
        end

        describe 'class method: ok_to_mutate' do
          it 'should return false if a chromosome\'s normalized fitness is good enough' do
            @normalized_fitness, @random = rand, rand
            @chromosome.normalized_fitness = @normalized_fitness
            MeetingsScheduler::Chromosome.stub!(:random).and_return @random
            MeetingsScheduler::Chromosome.ok_to_mutate(@chromosome).should == (@random < ((1 - @chromosome.normalized_fitness) * 0.3)) ? true : false
          end
        end
      
        describe 'class method: pick_two_random_indexes' do
          before(:each) do
            @length = rand(100)
            @chromosome = mock('MeetingsScheduler::Chromosome', :length => @length)
            @index1, @index2 = MeetingsScheduler::Chromosome.pick_two_random_indexes(@chromosome)
          end
          it 'should have the second integer be larger than the first' do 
            @index2.should > @index1+1 
          end
          
          it 'should be integers in the proper range' do
            @index1.should > 0
            @index1.should < @length-3
            @index2.should > 2
            @index2.should < @length-1
          end      
        end 
      end    

      describe 'create_solution_string' do
        before(:each) do
          @length = @factors_to_consider[:total_number_of_seats]
          @number_of_spots_per_student = @factors_to_consider[:number_of_spots_per_admit]
          @solution_string = MeetingsScheduler::Chromosome.create_solution_string
        end

        it 'should return an Array of admid_id\'s, with the correct length' do
          @solution_string.class.should == Array
          @solution_string.length.should == @length
          @solution_string.delete_if{ |id| id == nil }.each do |possible_id|
            @factors_to_consider[:attending_admits].keys.include?(possible_id).should == true
          end
        end

        it "should return an Array of admit_id\'s, and none of the array element should be nil" do
          @solution_string.each do |admit_id|
            admit_id.should_not be nil
          end
        end
      end

      describe 'seed' do
        it 'should call create_solution_string to generate an Array of admit_id\'s and pass it to new' do
          @solution_string = mock('solution_string')
          MeetingsScheduler::Chromosome.stub!(:create_solution_string).and_return(@solution_string)
          MeetingsScheduler::Chromosome.should_receive(:create_solution_string).once
          MeetingsScheduler::Chromosome.should_receive(:new).once.with(@solution_string)
          MeetingsScheduler::Chromosome.seed
        end
      end
      
      describe 'reproduce' do      
        before(:each) do
          @double_crossover_probability = @factors_to_consider[:double_crossover_probability]
          @solution_string = create_valid_solution_string(@factors_to_consider)
          @parent1 = MeetingsScheduler::Chromosome.new(@solution_string)
          @parent2 = MeetingsScheduler::Chromosome.new(@solution_string)
        end

        it 'should choose to double crossover #{@double_crossover_probability*100.0}% of the time' do
          @rand_index1, @rand_index2 = MeetingsScheduler::Chromosome.pick_two_random_indexes(@parent1)
          MeetingsScheduler::Chromosome.stub!(:rand).and_return(rand(100*@double_crossover_probability)/100.0)
          MeetingsScheduler::Chromosome.stub!(:pick_two_random_indexes).and_return [@rand_index1, @rand_index2]
          MeetingsScheduler::Chromosome.stub!(:double_crossover)
          MeetingsScheduler::Chromosome.should_receive(:double_crossover).once.with(@parent1, @parent2, @rand_index1, @rand_index2)
          MeetingsScheduler::Chromosome.reproduce(@parent1, @parent2)
        end

        it 'should choose to single crossover as default' do
          @rand_index = rand(@parent1.length - 2) + 1
          MeetingsScheduler::Chromosome.stub!(:rand).and_return(rand + @double_crossover_probability, @rand_index)
          MeetingsScheduler::Chromosome.stub!(:single_crossover)
          MeetingsScheduler::Chromosome.should_receive(:single_crossover).once.with(@parent1, @parent2, @rand_index+1)
          MeetingsScheduler::Chromosome.reproduce(@parent1, @parent2)
        end
      end 
      
      describe 'Reproduction helper methods' do
        before(:each) do
          @solution_string = create_valid_solution_string(@factors_to_consider)
          @parent1 = MeetingsScheduler::Chromosome.new(@solution_string)
          @parent2 = MeetingsScheduler::Chromosome.new(@solution_string)
        end

        describe 'class method: single_crossover' do
          it 'should return a new chromosome with the proper single swap' do
            @splice_index = rand(@parent1.length - 2) + 1
            @child = MeetingsScheduler::Chromosome.single_crossover(@parent1, @parent2, @splice_index)
            @child.class.should == MeetingsScheduler::Chromosome
            @child.should == MeetingsScheduler::Chromosome.new(@parent1[0...@splice_index] + @parent2[@splice_index..-1])
          end   
        end

        describe 'class method: double_crossover' do
          it 'should return a new chromosome with the proper double swap' do
            @index1, @index2 = MeetingsScheduler::Chromosome.pick_two_random_indexes(@parent1)
            @child = MeetingsScheduler::Chromosome.double_crossover(@parent1, @parent2, @index1, @index2)
            @child.class.should == MeetingsScheduler::Chromosome
            @child.should == MeetingsScheduler::Chromosome.new(@parent1[0...@index1] + @parent2[@index1...@index2] + @parent1[@index2..-1])
          end
        end
      end
      
      describe 'Fitness function score helper methods' do
        before(:each) do
          @fitness_scores_table = create_valid_fitness_scores_table
          MeetingsScheduler::Chromosome.set_fitness_scores_table(@fitness_scores_table)
        end

        describe 'class method: fitness_of_nucleotide' do
          before(:each) do
            @nucleotide = mock('Nucleotide', :admit_id => rand(100))
          end
          it 'should return the sum of all fitness criteria subscores of a single nucleotide, if physical arrangement is possible' do
            @randA, @randB, @randC = rand(1000), rand(1000), rand(1000)
            MeetingsScheduler::Chromosome.stub!(:is_meeting_possible_score).and_return @fitness_scores_table[:is_meeting_possible_score]
            MeetingsScheduler::Chromosome.stub!(:admit_preference_score).and_return(@randA)
            MeetingsScheduler::Chromosome.stub!(:faculty_preference_score).and_return(@randB)
            MeetingsScheduler::Chromosome.stub!(:area_match_score).and_return(@randC)
            MeetingsScheduler::Chromosome.fitness_of_nucleotide(@nucleotide).should == @fitness_scores_table[:is_meeting_possible_score] +
              @randA + @randB + @randC
          end
          it 'should just return a penalty for impossible arrangement if physical arrangement described by a single nucleotide is impossible' do
            MeetingsScheduler::Chromosome.stub!(:is_meeting_possible_score).and_return @fitness_scores_table[:is_meeting_possible_penalty]
            MeetingsScheduler::Chromosome.fitness_of_nucleotide(@nucleotide).should == @fitness_scores_table[:is_meeting_possible_penalty]
          end

          it 'should return 0 if the nucleotide is nil (has a nil admit_id)' do
            @nil_nucleotide = mock('Nucleotide', :admit_id => nil)
            MeetingsScheduler::Chromosome.fitness_of_nucleotide(@nil_nucleotide).should == 0
          end
        end
        
        describe 'class method: meeting_possible_score' do
          
          before(:each) do  
            @admit = create_valid_admit_hash(1)
            @faculty = create_valid_faculty_hash(1)
          end

          it 'should return a score if a meeting arrangement defined by a single nucleotide is physically possible' do
            @schedule_index = 1
            @nucleotide = MeetingsScheduler::Nucleotide.new(@faculty, @schedule_index, @admit)
    
            MeetingsScheduler::Chromosome.is_meeting_possible_score(@nucleotide).should == @fitness_scores_table[:is_meeting_possible_score]
          end

          it 'should return a penalty if a meeting arrangement defined by a single nucleotide is physically impossible' do
            @schedule_index = 0
            @nucleotide = MeetingsScheduler::Nucleotide.new(@faculty, @schedule_index, @admit)
            
            MeetingsScheduler::Chromosome.is_meeting_possible_score(@nucleotide).should == @fitness_scores_table[:is_meeting_possible_penalty]
          end        
        end
      
        describe 'class method: find_faculty_ranking' do
          it 'should return the ADMIT\'s ranking that contains the faculty' do
            @faculty_id = rand(100)
            @faculty = { :id => @faculty_id }
            @ranking = { :faculty_id  => @faculty_id }
            @admit = { :rankings => (rand(20).times.collect{ |id| { :faculty_id => "Non-id #{id}" }} + [@ranking]).shuffle.shuffle }
            MeetingsScheduler::Chromosome.find_faculty_ranking(@admit, @faculty).should == @ranking
          end
        end
      
        describe 'class method: find_admit_ranking' do
          it 'should return the FACULTY\'s ranking that contains the admit' do
            @admit_id = rand(100)
            @admit = { :id => @admit_id }
            @ranking = { :admit_id  => @admit_id }
            @faculty = { :rankings => (rand(20).times.collect{ |id| { :admit_id => "Non-id #{id}" }} + [@ranking]).shuffle.shuffle }          
            MeetingsScheduler::Chromosome.find_admit_ranking(@admit, @faculty).should == @ranking
          end
        end      
    
        describe 'class method: faculty_preference_score' do
          before(:each) do
            @admit = create_valid_admit_hash(1)
            @faculty = create_valid_faculty_hash(1)
            @schedule_index = 0 #some arbitrary number because it does not affect the faculty_preference_score function
            @nucleotide = MeetingsScheduler::Nucleotide.new(@faculty, @schedule_index, @admit)
          end

          it 'should return a rank-weighted score if a faculty is among an ADMIT\'s ranking' do
            @ranking = { :rank => rand(@factors_to_consider[:number_of_spots_per_admit]) }            
            MeetingsScheduler::Chromosome.stub!(:find_faculty_ranking).and_return(@ranking)
            MeetingsScheduler::Chromosome.should_receive(:find_faculty_ranking).once.with(@admit, @faculty)

            MeetingsScheduler::Chromosome.faculty_preference_score(@nucleotide).should ==
              @fitness_scores_table[:faculty_ranking_weight_score] * (@factors_to_consider[:lowest_rank_possible]+1 - @ranking[:rank])
          end

          it 'should return a default score if a faculty is not among an ADMIT\'s ranking' do
            MeetingsScheduler::Chromosome.stub!(:find_faculty_ranking).and_return nil
            MeetingsScheduler::Chromosome.should_receive(:find_faculty_ranking).once.with(@admit, @faculty)

            MeetingsScheduler::Chromosome.faculty_preference_score(@nucleotide).should ==
              @fitness_scores_table[:faculty_ranking_default]
          end        
        end
        
        describe 'class method: admit_preference_score' do
          before(:each) do
            @admit = create_valid_admit_hash(1)
            @faculty = create_valid_faculty_hash(1)
            @schedule_index = 0 #some arbitrary number because it does not affect the faculty_preference_score function
            @nucleotide = MeetingsScheduler::Nucleotide.new(@faculty, @schedule_index, @admit)
                   
            @meeting_solution = mock('meeting_solution')
            @ranking = { :rank => rand(@factors_to_consider[:number_of_spots_per_admit]) } # should be same as :lowest_rank_possible
          end

          it 'should compute a rank-weighted score if an admit is among a FACULTY\'s ranking' do
            MeetingsScheduler::Chromosome.stub!(:one_on_one_score).and_return(0)
            MeetingsScheduler::Chromosome.stub!(:mandatory_meeting_score).and_return(0)          
            MeetingsScheduler::Chromosome.stub!(:find_admit_ranking).and_return(@ranking)
            MeetingsScheduler::Chromosome.should_receive(:find_admit_ranking).once.with(@admit, @faculty)

            MeetingsScheduler::Chromosome.admit_preference_score(@meeting_solution, @nucleotide).should ==
              @fitness_scores_table[:admit_ranking_weight_score] * (@factors_to_consider[:lowest_rank_possible]+1 - @ranking[:rank])
          end

          it 'should further compute and add one-on-one and mandatory-meeting scores if an admit is among a FACULTY\'s ranking' do
            @one_on_one_score, @mandatory_meeting_score = rand(20)+1, rand(20)+1
            MeetingsScheduler::Chromosome.stub!(:one_on_one_score).and_return(@one_on_one_score)
            MeetingsScheduler::Chromosome.stub!(:mandatory_meeting_score).and_return(@mandatory_meeting_score)
            MeetingsScheduler::Chromosome.stub!(:find_admit_ranking).and_return(@ranking)

            MeetingsScheduler::Chromosome.should_receive(:one_on_one_score).once.with(@meeting_solution, @nucleotide, @ranking)
            MeetingsScheduler::Chromosome.should_receive(:mandatory_meeting_score).once.with(@ranking)
            MeetingsScheduler::Chromosome.admit_preference_score(@meeting_solution, @nucleotide).should ==
              @fitness_scores_table[:admit_ranking_weight_score] * (@factors_to_consider[:lowest_rank_possible]+1 - @ranking[:rank]) +
              @one_on_one_score + @mandatory_meeting_score
          end

          it 'should return a default score if an admit is not among a FACULTY\'s ranking' do
            MeetingsScheduler::Chromosome.stub!(:find_admit_ranking).and_return nil
            MeetingsScheduler::Chromosome.should_receive(:find_admit_ranking).once.with(@admit, @faculty)
            MeetingsScheduler::Chromosome.admit_preference_score(@meeting_solution, @nucleotide).should ==
              @fitness_scores_table[:admit_ranking_default]
          end
        end        
        
        describe 'class method: one_on_one_score' do        
          before(:each) do
            @admit = create_valid_admit_hash(1)
            @faculty = create_valid_faculty_hash(1)
            @schedule_index = 0 #some arbitrary number because it does not affect the faculty_preference_score function
            @nucleotide = MeetingsScheduler::Nucleotide.new(@faculty, @schedule_index, @admit)            
            @meeting_solution = mock('meeting_solution')
            @admit_in_meeting = mock('admit_in_meeting')
            MeetingsScheduler::Chromosome.stub!(:find_admits_in_meeting).and_return(@admit_in_meeting)
          end

          it 'should return a score when a FACULTY\'s admit ranking request for one-to-one meeting has been met' do
            @ranking = { :one_on_one => true }
            MeetingsScheduler::Chromosome.stub!(:only_one_admit_in_meeting).and_return true
            MeetingsScheduler::Chromosome.should_receive(:only_one_admit_in_meeting).once.with(@admit_in_meeting, @admit)
            MeetingsScheduler::Chromosome.one_on_one_score(@meeting_solution, @nucleotide, @ranking).should ==
              @fitness_scores_table[:one_on_one_score]
          end

          it 'should return a penalty when a FACULTY\'s admit ranking request for one-to-one meeting has not been met' do
            @ranking = { :one_on_one => true}
            MeetingsScheduler::Chromosome.stub!(:only_one_admit_in_meeting).and_return false
            MeetingsScheduler::Chromosome.should_receive(:only_one_admit_in_meeting).once.with(@admit_in_meeting, @admit)
            MeetingsScheduler::Chromosome.one_on_one_score(@meeting_solution, @nucleotide, @ranking).should ==
              @fitness_scores_table[:one_on_one_penalty]
          end

          it 'should return a default score when a FACULTY\'s admit ranking did not request for a one-to-one meeting' do
            @ranking = { :one_on_one => false}
            MeetingsScheduler::Chromosome.one_on_one_score(@meeting_solution, @nucleotide, @ranking).should ==
              @fitness_scores_table[:one_on_one_default]
          end
        end
        
        describe 'class method: area_match_score' do
          it 'should return the appropriate points when a faculty\'s areas of research matches one of an admit\'s areas of interest' do
            @admit = create_valid_admit_hash(1)
            @faculty = create_valid_faculty_hash(1)
            @faculty[:area] = 'subjectA' 
            @admit[:area1] = 'subjectA'
            @admit[:area2] = 'subjectC'
            @schedule_index = 0 #some arbitrary number because it does not affect the faculty_preference_score function
            @nucleotide = MeetingsScheduler::Nucleotide.new(@faculty, @schedule_index, @admit)
            MeetingsScheduler::Chromosome.area_match_score(@nucleotide).should == @fitness_scores_table[:area_match_score]
          end

          it 'should return the appropriate default when a faculty\'s areas of research does not match any one of an admit\'s areas of interest' do
            @admit = create_valid_admit_hash(1)
            @faculty = create_valid_faculty_hash(1)
            @faculty[:area] = 'subjectA' 
            @admit[:area1] = 'subjectB'
            @admit[:area2] = 'subjectC'
            @schedule_index = 0 #some arbitrary number because it does not affect the faculty_preference_score function
            @nucleotide = MeetingsScheduler::Nucleotide.new(@faculty, @schedule_index, @admit)
            MeetingsScheduler::Chromosome.area_match_score(@nucleotide).should == @fitness_scores_table[:area_match_default]
          end
        end        
                      
        describe 'class method: find_admits_in_meeting' do
          it 'should return just a subset of admit_id\'s that are in a specific timeslot for a specific faculty' do
            @solution_string = create_valid_solution_string(@factors_to_consider)
            @chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
            @meeting_solution = @chromosome.meeting_solution
            
            @meeting_solution.each do |nucleotide_one|         
              MeetingsScheduler::Chromosome.find_admits_in_meeting(@meeting_solution, nucleotide_one.faculty, nucleotide_one.schedule_index).sort.should ==
              @meeting_solution.find_all{ |nucleotide_two| nucleotide_two.faculty_id == nucleotide_one.faculty_id and nucleotide_two.schedule_index == nucleotide_one.schedule_index }.collect{ |nucleotide| nucleotide.admit_id }.sort
            end
          end        
        end      
      
        describe 'class method: only_one_admit_in_meeting' do
          before(:each) do
            @admit = { :id => 1 }
          end

          it 'should return true if the admit\'s id is the only unique one in an array of admit_id\'s, excluding nils' do        
            @admits_in_meeting = (Array.new(19) + [1]).shuffle.shuffle
            MeetingsScheduler::Chromosome.only_one_admit_in_meeting(@admits_in_meeting, @admit).should == true
          end

          it 'should return false if the admit\'s id is not the only unique id in an array of admit_id\'s' do
            @admits_in_meeting = (Array.new(18) + (1..2).collect).shuffle.shuffle
            MeetingsScheduler::Chromosome.only_one_admit_in_meeting(@admits_in_meeting, @admit).should == false          
          end

          it 'should return false if the admit\'s id is not in an array of admit_id\'s' do
            @admits_in_meeting = (Array.new(19) + [2]).shuffle.shuffle
            MeetingsScheduler::Chromosome.only_one_admit_in_meeting(@admits_in_meeting, @admit).should == false
          end
        end      
      
        describe 'class method: mandatory_meeting_score' do
          [true, false].each do |val|
            it "should return the appropriate points for whether a FACULTY\'s admit ranking is marked #{val}" do
              @ranking = { :mandatory => val }
              score = val ? @fitness_scores_table[:mandatory_score] : @fitness_scores_table[:mandatory_default]
              MeetingsScheduler::Chromosome.mandatory_meeting_score(@ranking).should == score
            end
          end
        end
  
        describe 'Duplicates removal and helper methods' do
          before (:each) do
            @solution_string = create_valid_solution_string(@factors_to_consider)
            @chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
            @meeting_solution = @chromosome.meeting_solution
          end

          describe 'remove_duplicates' do
            it 'should return a new meeting_solution (array of Nucleotides) with duplicate admit_ids per faculty removed' do
              MeetingsScheduler::Chromosome.stub!(:new).and_return(mock('meeting_solution', :meeting_solution => @meeting_solution))          
              MeetingsScheduler::Chromosome.stub!(:remove_duplicate_admits_from_faculty!)
              @factors_to_consider[:faculties].each do |faculty_id, faculty|
                MeetingsScheduler::Chromosome.should_receive(:remove_duplicate_admits_from_faculty!).once.with(@meeting_solution, faculty)
              end
              MeetingsScheduler::Chromosome.remove_duplicates(@solution_string)
            end
          end

          describe 'class method: remove_duplicate_admits_from_faculty!' do
            it 'should get a list of admit_ids that are duplicate throughout the chromosome' do
              @meeting_solution, @faculty  = mock('meeting_solution'), mock('faculty')
              @duplicate_admit_ids = rand(100).times.collect.shuffle.shuffle
              MeetingsScheduler::Chromosome.stub!(:get_duplicate_admit_ids).and_return(@duplicate_admit_ids)
              MeetingsScheduler::Chromosome.stub!(:remove_duplicate_spots_for_admit!)
              @duplicate_admit_ids.each do |id|
                MeetingsScheduler::Chromosome.should_receive(:remove_duplicate_spots_for_admit!).once.with(@meeting_solution, @faculty, id)
              end
              MeetingsScheduler::Chromosome.remove_duplicate_admits_from_faculty!(@meeting_solution, @faculty)
            end
          end

          describe 'class method: remove_duplicate_spots_for_admit!' do
            it 'should remove duplicate spots of one admit under a faculty\'s nucleotides' do
              @duplicate_nucleotides, @best_nucleotide =  mock('duplicate_nucleotides'), mock('best_nucleotide')
              @meeting_solution, @faculty, @admit_id = mock('meeting_solution'), mock('faculty'), mock('admit_id')
              MeetingsScheduler::Chromosome.stub!(:get_duplicate_nucleotides_for_admit).and_return(@duplicate_nucleotides)
              MeetingsScheduler::Chromosome.stub!(:pick_out_best_nucleotide).and_return(@best_nucleotide)
              MeetingsScheduler::Chromosome.stub!(:reset_non_optimal_nucleotides!)
              MeetingsScheduler::Chromosome.should_receive(:get_duplicate_nucleotides_for_admit).once.with(@meeting_solution, @faculty, @admit_id)
              MeetingsScheduler::Chromosome.should_receive(:pick_out_best_nucleotide).once.with(@duplicate_nucleotides)
              MeetingsScheduler::Chromosome.should_receive(:reset_non_optimal_nucleotides!).once.with(@duplicate_nucleotides, @best_nucleotide)
              MeetingsScheduler::Chromosome.remove_duplicate_spots_for_admit!(@meeting_solution, @faculty, @admit_id)
            end
          end

          describe 'class method: reset_non_optimal_nucleotides!' do
            it 'should set the non-optimal duplicate nucleotides to nil admit_ids' do
              @faculty_id = @factors_to_consider[:faculties].keys.shuffle.shuffle.fetch(0)
              @admit_id = nil
              while @admit_id.nil?
                @admit_id = @meeting_solution[rand(@length)]
              end          
              @duplicate_nucleotides = @meeting_solution.find_all{ |n| n.faculty_id == @faculty_id and n.admit_id == @admit_id }
              @best_nucleotide = @duplicate_nucleotides[rand(@duplicate_nucleotides.length)]

              MeetingsScheduler::Chromosome.reset_non_optimal_nucleotides!(@duplicate_nucleotides, @best_nucleotide)
              @duplicate_nucleotides.each do |n|
                if n.schedule_index != @best_nucleotide.schedule_index
                  n.admit_id.should == nil
                end
              end
            end
          end

          describe 'class method: get_duplicate_nucleotides_for_admit' do
            it 'should should return all nucleotides belonging to a Faculty with the same admit_ids' do
              @faculty_id = @factors_to_consider[:faculties].keys.shuffle.shuffle.fetch(0)
              @admit_id = @meeting_solution.shuffle.shuffle.fetch(0).admit_id          
              @faculty = { :id => @faculty_id }
              MeetingsScheduler::Chromosome.get_duplicate_nucleotides_for_admit(@meeting_solution, @faculty, @admit_id).should ==
                @meeting_solution.find_all{ |n| n.faculty_id == @faculty_id and n.admit_id == @admit_id }
            end
          end

          describe 'class method: get_duplicate_admits' do
            it 'should return an array of admit_ids that appear more than once in a set of nucleotides with a given faculty_id' do
              @faculty_id = @meeting_solution.shuffle.shuffle.fetch(0).faculty_id
              @faculty = { :id => @faculty_id }
              MeetingsScheduler::Chromosome.get_duplicate_admit_ids(@meeting_solution, @faculty).should ==
                @meeting_solution.find_all{ |n| n.faculty_id == @faculty_id }.collect{ |n| n.admit_id }.inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
            end
          end

          describe 'class method: dups' do
            it 'should return an array of elements that are duplicates in an input array' do
              @dup1, @dup2 = rand(100), rand(100)+100
              @array = (200.upto(1000).collect + [@dup1]*(rand(20)+2) + [@dup2]*(rand(20)+2)).shuffle.shuffle
              MeetingsScheduler::Chromosome.dups(@array).sort.should == [@dup1, @dup2]
            end
          end

        end     
         
      end
    end   
  end
    
  describe MeetingsScheduler::Nucleotide do
    describe 'Nucleotide attributes' do
      before(:each) do
        faculty_hash = create_valid_faculty_hash(15)
        admit_hash = create_valid_admit_hash(20)
        schedule_index = 5
        @nucleotide = MeetingsScheduler::Nucleotide.new(faculty_hash, schedule_index, admit_hash)
      end
      
      it 'has a schedule_index' do 
        @nucleotide.should respond_to(:schedule_index) 
      end
      
      it "responds to faculty" do
        @nucleotide.should respond_to(:faculty)
      end
      
      it "responds to faculty_id" do
        @nucleotide.should respond_to(:faculty_id)
      end
      
      it "responds to admit" do
        @nucleotide.should respond_to(:admit)
      end
      
      it "responds to admit_id" do
         @nucleotide.should respond_to(:admit_id)
      end
      
      it "should return 15 when calling nucleotide.faculty_id with its faculty[:id] = 15" do
        @nucleotide.faculty_id.should == 15
      end
      
      it "should return 20 when calling nucleotide.admit_id with its admit_id[:id] = 20" do
        @nucleotide.admit_id.should == 20
      end
      
      it 'is comparable to another nucleotide' do 
        faculty_hash = create_valid_faculty_hash(15)
        admit_hash = create_valid_admit_hash(20)
        @nucleotide.==(MeetingsScheduler::Nucleotide.new(faculty_hash,5,admit_hash)).should == true 
      end
    end
  end
  
end

## Helper Methods to set up valid factors_to_consider and fitness_scores_table hashes

def create_valid_factors_hash
  double_crossover_probability = rand
  chromosomal_inversion_probability = rand
  point_mutation_probability = rand 
  
  while chromosomal_inversion_probability + point_mutation_probability > 1
    point_mutation_probability = rand 
  end
  
  
  faculties = 4.times.collect{ |id| create_valid_faculty_hash(id+100) }
  attending_admits = 4.times.collect{ |id| create_valid_admit_hash(id) }  
  
  faculties = {
    faculties[0][:id] => faculties[0],
    faculties[1][:id] => faculties[1],
    faculties[2][:id] => faculties[2],
    faculties[3][:id] => faculties[3]
  }
    
  attending_admits = {
    attending_admits[0][:id] => attending_admits[0],
    attending_admits[1][:id] => attending_admits[1],
    attending_admits[2][:id] => attending_admits[2],
    attending_admits[3][:id] => attending_admits[3]
  }
  
  lowest_rank_possible = 5
  
  total_number_of_seats = faculties.collect do |faculty_id, faculty|
    faculty[:schedule].collect{ |room_timeslot_pair| faculty[:max_students_per_meeting].times.collect }
  end
  
  total_number_of_seats = total_number_of_seats.flatten.count
  #total_number_of_meetings = faculties.collect{ |faculty_id, faculty| faculty[:schedule].count }.inject(:+)
  
  number_of_spots_per_admit = (total_number_of_seats / attending_admits.length).floor - 1
  
  return {
    :total_number_of_seats             => total_number_of_seats,
    :number_of_spots_per_admit         => number_of_spots_per_admit,
    :chromosomal_inversion_probability => chromosomal_inversion_probability,
    :point_mutation_probability        => point_mutation_probability,
    :double_crossover_probability      => double_crossover_probability,
    :lowest_rank_possible              => lowest_rank_possible,
    :attending_admits                  => attending_admits,
    :faculties                         => faculties
  }
end


def create_valid_solution_string(factors_to_consider)
  
  attending_admits = factors_to_consider[:attending_admits]
  total_number_of_seats = factors_to_consider[:total_number_of_seats]
  number_of_spots_per_admit = factors_to_consider[:number_of_spots_per_admit]
   
  solution_string = Array.new(total_number_of_seats)
   
  admit_ids = (attending_admits.keys * number_of_spots_per_admit).shuffle.shuffle
   
  admit_ids.each do |id|
    index = rand(total_number_of_seats)
    while solution_string[index] # if the spot is occupied, we find a new spot
      index = rand(total_number_of_seats)
    end
    solution_string[index] = id
  end
  
  solution_string.each_with_index do |admit_id, index|
    if admit_id == nil
      solution_string[index] = attending_admits.keys[rand(attending_admits.length)]
    end
  end
  
  return solution_string
end

def create_valid_faculty_hash(id)
  {
    :id                       => id,
    :max_students_per_meeting => rand(4)+1,
    :admit_rankings           => [],
    :schedule                 => [{:room => 'room1', :time_slot => 1.hour.from_now..5.hours.from_now},
                                  {:room => 'room2', :time_slot => 32.hours.from_now..45.hours.from_now}]
  }
end

def create_valid_admit_hash(id)
  {
    :id              => id,
    :name            => "Admit<#{id}>",
    :ranking         => [],
    :available_times => RangeSet.new([1.day.from_now..2.days.from_now,
                                      3.days.from_now..4.days.from_now])
  }
end

def create_valid_fitness_scores_table
  return {
    :is_meeting_possible_score       => rand(100),
    :is_meeting_possible_penalty     => -rand(100),
    :faculty_ranking_weight_score => rand(100),
    :faculty_ranking_default      => rand(100),
    :admit_ranking_weight_score   => rand(100),
    :admit_ranking_default        => rand(100),
    :area_match_score             => rand(100),
    :area_match_default           => rand(100),
    :one_on_one_score             => rand(100),
    :one_on_one_penalty           => -rand(100),
    :one_on_one_default           => rand(100),
    :mandatory_score              => rand(100),
    :mandatory_default            => rand(100)
  }
end