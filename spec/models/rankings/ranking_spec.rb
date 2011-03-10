require 'spec_helper'

describe Ranking do
  context 'when ordering by score' do
    before(:each) do
      @settings = Settings.instance
      Settings.stub(:instance).and_return(@settings)
      @settings.stub(:faculty_weight).and_return(10)
      @settings.stub(:admit_weight).and_return(1)
      @settings.stub(:rank_weight).and_return(1)
      @settings.stub(:mandatory_weight).and_return(10)
    end

    it 'has a list of Rankings sorted in decreasing order of score' do
      rank1 = Factory.create(:admit_ranking, :rank => 1, :mandatory => true)
      rank2 = Factory.create(:admit_ranking, :rank => 1, :mandatory => false)
      rank3 = Factory.create(:admit_ranking, :rank => 2, :mandatory => false)
      rank4 = Factory.create(:admit_ranking, :rank => 3, :mandatory => true)
      rank5 = Factory.create(:faculty_ranking, :rank => 1)
      rank6 = Factory.create(:faculty_ranking, :rank => 2)
      rank7 = Factory.create(:faculty_ranking, :rank => 3)
      Ranking.by_rank.should == [rank1, rank4, rank2, rank3, rank5, rank6, rank7]
    end
  end
end
