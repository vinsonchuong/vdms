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

    it 'has an attribute name to accessor map' do
      AdmitRanking::ATTRIBUTES['Rank'].should == :rank
      AdmitRanking::ATTRIBUTES['Mandatory'].should == :mandatory
      AdmitRanking::ATTRIBUTES['Time Slots'].should == :time_slots
      AdmitRanking::ATTRIBUTES['One-On-One'].should == :one_on_one
    end

    it 'has an accessor to type map' do
      AdmitRanking::ATTRIBUTE_TYPES[:rank].should == :integer
      AdmitRanking::ATTRIBUTE_TYPES[:mandatory].should == :boolean
      AdmitRanking::ATTRIBUTE_TYPES[:time_slots].should == :integer
      AdmitRanking::ATTRIBUTE_TYPES[:one_on_one].should == :boolean
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
      existent_admit_ranking = Factory.create(:admit_ranking, :rank => 1, :faculty => faculty)
      new_admit_ranking = Factory.build(:admit_ranking, :rank => 1, :faculty => faculty)
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
      @admit_ranking.faculty.destroy
      @admit_ranking.should_not be_valid
    end

    it 'is not valid with an invalid Admit' do
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
end
