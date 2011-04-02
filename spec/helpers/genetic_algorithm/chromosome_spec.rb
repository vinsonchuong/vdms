#require 'spec_helper'

#describe MeetingsScheduler::GeneticAlgorithm::Chromosome do
=begin
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
      ['', '='].each do |val|
        it "should respond to meeting_solution#{val}" do
          @chromosome.should respond_to("meeting_solution#{val}".to_sym)
        end
      end

      it 'should return a meeting_solution, which is an array of nucleotides' do
        @chromosome.meeting_solution.class.should == Array
        @chromosome.meeting_solution.each do |nucleotide|
          nucleotide.class.should == MeetingsScheduler::Nucleotide
        end
      end
    end

    describe "normalized_fitness" do
      ['', '='].each do |val|
        it "should respond to normalized_fitness#{val}" do
          @chromosome.should respond_to("normalized_fitness#{val}".to_sym)
        end
      end
    end
  end

  describe "Instance Methods:" do
    before(:each) do
      @solution_string = create_valid_solution_string(@factors_to_consider)
      # DO NOT DELETE SOLUTION_STRING_COPY, BECAUSE CHROMOSOME.INITIALIZE MUTATES SOLUTION_STRING BY SLOWLY SLICING ALL ELEMENTS OUT!!!
      @solution_string_copy = Array.new(@solution_string)
      @chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
    end

    describe "solution_string" do
      it "should respond to solution_string" do
        @chromosome.should respond_to(:solution_string)
      end

      it 'should return an Array encoding a solution of admit_id\'s' do
        @chromosome.solution_string.should == @solution_string_copy
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

      it 'should return true if two chromosomes have equivalent fitness values' do
        @chromosome2 = MeetingsScheduler::Chromosome.new(@solution_string_copy)
        @chromosome.stub!(:fitness).and_return(@fitness = rand(100))
        @chromosome2.stub!(:fitness).and_return(@fitness)
        @chromosome.==(@chromosome2).should == true
      end

      it 'should return false if two chromosomes have nonequivalent fitness values' do
        @chromosome2 = MeetingsScheduler::Chromosome.new(@solution_string_copy)
        @chromosome.stub!(:fitness).and_return(rand(100))
        @chromosome2.stub!(:fitness).and_return(rand(100)+100)
        @chromosome.==(@chromosome2).should == false
      end
    end

    describe 'instance method: fitness' do
      before(:each) do
        @nucleotide_fitness = rand(1000)
        MeetingsScheduler::Chromosome.stub!(:reduced_meeting_solution).and_return(@chromosome.meeting_solution)
        @chromosome.meeting_solution.each{ |n| n.stub!(:fitness).and_return(@nucleotide_fitness) }
        @chromosome.stub!(:reduced_meeting_solution).and_return(@chromosome.meeting_solution)
        @chromosome.stub!(:chromosome_level_fitness).and_return(@chromosome_level_fitness = rand(1000))
      end

      it 'should respond to fitness' do
        @chromosome.should respond_to(:fitness)
      end

      it 'should first remove duplicates before evaluating fitness' do
        @chromosome.should_receive(:reduced_meeting_solution).once
        @chromosome.fitness
      end

      it 'should return the sum of the fitness scores of each nucleotide, nil or not, plus the chromosome-level fitness' do
        @chromosome.should_receive(:chromosome_level_fitness)
        @chromosome.fitness.should == @chromosome.meeting_solution.length * @nucleotide_fitness + @chromosome_level_fitness
      end
    end
  end

=begin
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
          @index1, @index2 = @chromosome.pick_two_random_indexes
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
          @chromosome.ok_to_mutate.should == (@random < ((1 - @chromosome.normalized_fitness) * 0.3)) ? true : false
        end
      end

      describe 'class method: pick_two_random_indexes' do
        before(:each) do
          @length = rand(100)
          @chromosome = mock('MeetingsScheduler::Chromosome', :length => @length)
          @index1, @index2 = @chromosome.pick_two_random_indexes
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
        @rand_index1, @rand_index2 = @chromosome.pick_two_random_indexes
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

      describe 'class method: find_admits_in_meeting' do
        it 'should return just a subset of admit_id\'s that are in a specific timeslot for a specific faculty' do
          @solution_string = create_valid_solution_string(@factors_to_consider)
          @chromosome = MeetingsScheduler::Chromosome.new(@solution_string)
          @meeting_solution = @chromosome.meeting_solution

          @meeting_solution.each do |nucleotide_one|
            MeetingsScheduler::Chromosome.find_admits_in_meeting(@meeting_solution, nucleotide_one.faculty, nucleotide_one.schedule_index).sort.should ==
            @meeting_solution.find_all{ |nucleotide_two| nucleotide_two.faculty_id == nucleotide_one.faculty_id and
              nucleotide_two.schedule_index == nucleotide_one.schedule_index }.collect{ |nucleotide| nucleotide.admit_id }.sort
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

    end
  end
=end
#end