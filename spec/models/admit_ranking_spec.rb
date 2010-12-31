require 'spec_helper'

describe AdmitRanking do
  describe 'Attributes' do
    before(:each) do
      @admit_ranking = AdmitRanking.new
    end

    it 'has a mandatory meeting flag (mandatory)' do
      @admit_ranking.should respond_to(:mandatory)
      @admit_ranking.should respond_to(:mandatory=)
    end

    it 'has a number of desired meeting time slots (time_slots)' do
      @admit_ranking.should respond_to(:time_slots)
      @admit_ranking.should respond_to(:time_slots=)
    end

    it 'has a one-on-one meeting flag (one_on_one)' do
      @admit_ranking.should respond_to(:one_on_one)
      @admit_ranking.should respond_to(:one_on_one=)
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
