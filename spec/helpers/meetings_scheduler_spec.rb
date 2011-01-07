require 'spec_helper'

describe MeetingsScheduler do

  describe MeetingsScheduler::GeneticAlgorithm do
    # GA specs here
  end
  
  
  describe MeetingsScheduler::Chromosome do
    describe 'Solutions' do
      before(:each) do
        @chromosome = MeetingsScheduler::Chromosome.new([1,2,3])
      end
      
      it 'has a encoding/representation of a solution' do
        @chromosome.should respond_to(:data)
        @chromosome.should respond_to(:data=)
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
          MeetingsScheduler::Chromosome.stub!(:admits_attending).and_return [create_valid!(Admit, :id => 1)]
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
