require 'spec_helper'

describe FacultyRanking do
  before(:each) do
    @faculty_ranking = Factory.create(:faculty_ranking)
  end

  describe 'Attributes' do
    it 'has a Rank (rank)' do
      @faculty_ranking.should respond_to(:rank)
      @faculty_ranking.should respond_to(:rank=)
    end
  end

  describe 'Associations' do
    it 'belongs to an Admit (admit)' do
      @faculty_ranking.should belong_to(:admit)
    end

    it 'belongs to a Faculty (faculty)' do
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
      pending
      @faculty_ranking.admit.destroy
      @faculty_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Faculty' do
      pending
      @faculty_ranking.faculty.destroy
      @faculty_ranking.should_not be_valid
    end

    it 'is not valid with a non-unique Faculty' do
      admit = Factory.create(:admit)
      faculty = Factory.create(:faculty)
      existent_faculty_ranking = Factory.create(:faculty_ranking, :admit => admit, :faculty => faculty)
      new_faculty_ranking = Factory.build(:faculty_ranking, :admit => admit, :faculty => faculty)
      new_faculty_ranking.should_not be_valid
    end
  end

  context 'when ordering by score' do
    before(:each) do
      @settings = Settings.instance
      Settings.stub(:instance).and_return(@settings)
      @settings.stub(:faculty_weight).and_return(10)
      @settings.stub(:admit_weight).and_return(1)
      @settings.stub(:rank_weight).and_return(1)
      @settings.stub(:mandatory_weight).and_return(10)
    end

    it 'has a score' do
      [1, 2, 3].each do |rank|
        @faculty_ranking.rank = rank
        @faculty_ranking.score.should == 1.0/rank.to_f
      end
    end
  end
end
