require 'spec_helper'

describe AdmitRanking do
  before(:each) do
    @admit_ranking = Factory.create(:admit_ranking)
  end

  describe 'Attributes' do
    it 'has a Rank (rank)' do
      @admit_ranking.should respond_to(:rank)
      @admit_ranking.should respond_to(:rank=)
    end

    it 'has a Mandatory flag (mandatory)' do
      @admit_ranking.should respond_to(:mandatory)
      @admit_ranking.should respond_to(:mandatory=)
    end

    it 'has a number of Time Slots (time_slots)' do
      @admit_ranking.should respond_to(:time_slots)
      @admit_ranking.should respond_to(:time_slots=)
    end

    it 'has a One-On-One flag (one_on_one)' do
      @admit_ranking.should respond_to(:one_on_one)
      @admit_ranking.should respond_to(:one_on_one=)
    end
  end

  describe 'Associations' do
    it 'belongs to a Faculty (faculty)' do
      @admit_ranking.should belong_to(:faculty)
    end

    it 'belongs to an Admit (admit)' do
      @admit_ranking.should belong_to(:admit)
    end
  end

  context 'when building' do
    it 'has by default a Mandatory flag of false' do
      @admit_ranking.mandatory.should == false
    end

    it 'has by default 1 Time Slot' do
      @admit_ranking.time_slots.should == 1
    end

    it 'has by default a One-On-One flag of false' do
      @admit_ranking.one_on_one.should == false
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @admit_ranking.should be_valid
    end

    it 'is not valid with an invalid Rank' do
      ['', 0, -1, 'foobar'].each do |invalid_rank|
        @admit_ranking.rank = invalid_rank
        @admit_ranking.should_not be_valid
      end
    end

    it 'is not valid with a non-unique Rank' do
      faculty = Factory.create(:faculty)
      admit = Factory.create(:admit)
      existent_admit_ranking = Factory.create(:admit_ranking, :rank => 1, :faculty => faculty, :admit => admit)
      new_admit_ranking = Factory.build(:admit_ranking, :rank => 1, :faculty => faculty, :admit => admit)
      new_admit_ranking.should_not be_valid
    end

    it 'is not valid without a Mandatory flag' do
      @admit_ranking.mandatory = nil
      @admit_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Time Slots' do
      [nil, '', 'foobar', 0, -1].each do |invalid_slots|
        @admit_ranking.time_slots = invalid_slots
        @admit_ranking.should_not be_valid
      end
    end

    it 'is not valid without a One-On-One flag' do
      @admit_ranking.one_on_one = nil
      @admit_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Faculty' do
      pending
      @admit_ranking.faculty.destroy
      @admit_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Admit' do
      pending
      @admit_ranking.admit.destroy
      @admit_ranking.should_not be_valid
    end

    it 'is not valid with a non-unique Admit' do
      faculty = Factory.create(:faculty)
      admit = Factory.create(:admit)
      existent_admit_ranking = Factory.create(:admit_ranking, :faculty => faculty, :admit => admit)
      new_admit_ranking = Factory.build(:admit_ranking, :faculty => faculty, :admit => admit)
      new_admit_ranking.should_not be_valid
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
      [[1, true], [2, true], [3, true], [1, false], [2, false], [3, false]].each do |rank, mandatory|
        @admit_ranking.rank = rank
        @admit_ranking.mandatory = mandatory
        @admit_ranking.score.should == 10.0 * (1.0/rank.to_f + 10*(mandatory ? 1 : 0))
      end
    end
  end
end
