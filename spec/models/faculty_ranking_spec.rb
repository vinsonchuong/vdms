require 'spec_helper'

describe AdmitRanking do
  describe 'Attributes' do
    before(:each) do
      @faculty_ranking = FacultyRanking.new
    end

    it 'has a Rank (rank)' do
      @faculty_ranking.should respond_to(:rank)
      @faculty_ranking.should respond_to(:rank=)
    end

    it 'has an attribute name to accessor map' do
      FacultyRanking::ATTRIBUTES['Rank'].should == :rank
    end
  end

  describe 'Associations' do
    before(:each) do
      @faculty_ranking = FacultyRanking.new
    end

    it 'belongs to an admit (admit)' do
      @faculty_ranking.should belong_to(:admit)
    end

    it 'belongs to a faculty (faculty)' do
      @faculty_ranking.should belong_to(:faculty)
    end
  end
end
