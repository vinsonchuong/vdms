require 'spec_helper'

describe AdmitRanking do
  describe 'Attributes' do
    before(:each) do
      @admit_ranking = AdmitRanking.new
    end

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

    it 'has an attribute name to accessor map' do
      AdmitRanking::ATTRIBUTES['Rank'].should == :rank
      AdmitRanking::ATTRIBUTES['Mandatory'].should == :mandatory
      AdmitRanking::ATTRIBUTES['Time Slots'].should == :time_slots
      AdmitRanking::ATTRIBUTES['One-On-One'].should == :one_on_one
    end
  end

  describe 'Associations' do
    before(:each) do
      @admit_ranking = AdmitRanking.new
    end

    it 'belongs to a faculty (faculty)' do
      @admit_ranking.should belong_to(:faculty)
    end

    it 'belongs to an admit (admit)' do
      @admit_ranking.should belong_to(:admit)
    end
  end
end
