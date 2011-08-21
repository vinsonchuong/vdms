require 'spec_helper'

describe VisitorRanking do
  before(:each) do
    @visitor_ranking = Factory.create(:visitor_ranking)
  end

  describe 'Attributes' do
    it 'has a Rank (rank)' do
      @visitor_ranking.should respond_to(:rank)
      @visitor_ranking.should respond_to(:rank=)
    end
  end

  describe 'Associations' do
    it 'belongs to a Ranker (ranker)' do
      @visitor_ranking.should belong_to(:ranker)
    end

    it 'belongs to a Rankable (rankable)' do
      @visitor_ranking.should belong_to(:rankable)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @visitor_ranking.should be_valid
    end

    it 'is not valid with an invalid Rank' do
      ['', 0, -1, 'foobar'].each do |invalid_rank|
        @visitor_ranking.rank = invalid_rank
        @visitor_ranking.should_not be_valid
      end
    end

   it 'is not valid with an invalid Ranker' do
      @visitor_ranking.ranker.destroy
      @visitor_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Rankable' do
      @visitor_ranking.rankable.destroy
      @visitor_ranking.should_not be_valid
    end

    it 'is not valid with a non-unique Rankable' do
      visitor_ranking2 = Factory.build(:visitor_ranking, :ranker => @visitor_ranking.ranker, :rankable => @visitor_ranking.rankable)
      visitor_ranking2.should_not be_valid
    end
  end

  context 'when ordering by score' do
    before(:each) do
      pending
      @settings = Settings.instance
      Settings.stub(:instance).and_return(@settings)
      @settings.stub(:faculty_weight).and_return(10)
      @settings.stub(:admit_weight).and_return(1)
      @settings.stub(:rank_weight).and_return(1)
      @settings.stub(:mandatory_weight).and_return(10)
    end

    it 'has a score' do
      [1, 2, 3].each do |rank|
        @visitor_ranking.rank = rank
        @visitor_ranking.score.should == 1.0/rank.to_f
      end
    end
  end
end
