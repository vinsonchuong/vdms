require 'spec_helper'

describe AdmitRanking do
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
