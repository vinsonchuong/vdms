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
      
      it 'has a description of solution fitness' do
        @chromosome.should respond_to(:fitness)
      end
      
      it 'has a normalized fitness value for purposes of GA' do
        @chromosome.should respond_to(:normalized_fitness)
        @chromosome.should respond_to(:normalized_fitness=)
      end

      it 'has an unmutable length' do
        @chromosome.should respond_to(:length)
      end

      it 'is accessible in an array-like fashion' do
        @chromosome.should respond_to(:[])
        @chromosome.should respond_to(:[]=)
      end
    end

    describe 'When seeding a new chromosome' do
      it 'should corrrectly determine the \'length\' of the chromosome' do
        # set up faculty models and stuff correctly
        MeetingsScheduler::Chromosome.chromosome_length.should == xxx        
      end

      it 'the seed method should return a new chromosome, with the correct length' do
        # set up faculty models and stuff correctly
        @chromosome = MeetingsScheduler::Chromosome.seed
        @chromosome.type.should == MeetingsScheduler::Chromosome
        @chromosome.length.should == xxx
      end
    end

    describe 'When reproducing to form children' do
      describe 'When performing single crossover' do

      end
      describe 'When performing double crossover' do

      end
    end

    describe 'When mutating chromosomes' do

    end
    
  end
end
