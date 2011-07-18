require 'spec_helper'

describe HostRanking do
  before(:each) do
    @host_ranking = Factory.create(:host_ranking)
  end

  describe 'Attributes' do
    it 'has a Rank (rank)' do
      @host_ranking.should respond_to(:rank)
      @host_ranking.should respond_to(:rank=)
    end

    it 'has a Mandatory flag (mandatory)' do
      @host_ranking.should respond_to(:mandatory)
      @host_ranking.should respond_to(:mandatory=)
    end

    it 'has a One-On-One flag (one_on_one)' do
      @host_ranking.should respond_to(:one_on_one)
      @host_ranking.should respond_to(:one_on_one=)
    end

    it 'has a Number of Time Slots (num_time_slots)' do
      @host_ranking.should respond_to(:num_time_slots)
      @host_ranking.should respond_to(:num_time_slots=)
    end
  end

  describe 'Associations' do
    it 'belongs to a Ranker (ranker)' do
      @host_ranking.should belong_to(:ranker)
    end

    it 'belongs to a Rankable (rankable)' do
      @host_ranking.should belong_to(:rankable)
    end
  end

  context 'when building' do
    it 'has by default a Mandatory flag of false' do
      @host_ranking.mandatory.should == false
    end

    it 'has by default a One-On-One flag of false' do
      @host_ranking.one_on_one.should == false
    end

    it 'has by default 1 Time Slot' do
      @host_ranking.num_time_slots.should == 1
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @host_ranking.should be_valid
    end

    it 'is not valid with an invalid Rank' do
      ['', 0, -1, 'foobar'].each do |invalid_rank|
        @host_ranking.rank = invalid_rank
        @host_ranking.should_not be_valid
      end
    end

    it 'is not valid without a Mandatory flag' do
      @host_ranking.mandatory = nil
      @host_ranking.should_not be_valid
    end

    it 'is not valid without a One-On-One flag' do
      @host_ranking.one_on_one = nil
      @host_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Number of Time Slots' do
      [nil, '', 'foobar', 0, -1].each do |invalid_slots|
        @host_ranking.num_time_slots = invalid_slots
        @host_ranking.should_not be_valid
      end
    end

    it 'is not valid with an invalid Ranker' do
      @host_ranking.ranker.destroy
      @host_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Rankable' do
      @host_ranking.rankable.destroy
      @host_ranking.should_not be_valid
    end

    it 'is not valid with a non-unique Rankable' do
      host_ranking2 = Factory.build(:host_ranking, :ranker => @host_ranking.ranker, :rankable => @host_ranking.rankable)
      host_ranking2.should_not be_valid
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
        @host_ranking.rank = rank
        @host_ranking.mandatory = mandatory
        @host_ranking.score.should == 10.0 * (1.0/rank.to_f + 10*(mandatory ? 1 : 0))
      end
    end
  end
end
