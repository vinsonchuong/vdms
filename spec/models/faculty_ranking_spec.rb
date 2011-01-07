require 'spec_helper'

describe FacultyRanking do
  before(:each) do
    @faculty_ranking = Factory.build(:faculty_ranking)
  end

  describe 'Attributes' do
    it 'has a Rank (rank)' do
      @faculty_ranking.should respond_to(:rank)
      @faculty_ranking.should respond_to(:rank=)
    end

    it 'has an attribute name to accessor map' do
      FacultyRanking::ATTRIBUTES['Rank'].should == :rank
    end
  end

  describe 'Associations' do
    it 'belongs to an admit (admit)' do
      @faculty_ranking.should belong_to(:admit)
    end

    it 'belongs to a faculty (faculty)' do
      @faculty_ranking.should belong_to(:faculty)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @faculty_ranking.should be_valid
    end

    it 'is not valid with an invalid Rank' do
      ['', 0, -1, 'foobar'].each do |invalid_rank|
        @faculty_ranking.rank = invalid_rank
        @faculty_ranking.should_not be_valid
      end
    end

    it 'is not valid with an invalid Admit' do
      @faculty_ranking.admit.destroy
      @faculty_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Faculty' do
      @faculty_ranking.faculty.destroy
      @faculty_ranking.should_not be_valid
    end
  end
end
