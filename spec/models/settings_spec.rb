require 'spec_helper'

describe Settings do
  before(:each) do
    @settings = Settings.instance
    @settings.save
  end

  describe 'Attributes' do
    it 'has an Unsatisfied Admit Threshold (unsatisfied_admit_threshold)' do
      @settings.should respond_to(:unsatisfied_admit_threshold)
      @settings.should respond_to(:unsatisfied_admit_threshold=)
    end

    it 'has a Disable Faculty From Making Changes flag (disable_faculty)' do
      @settings.should respond_to(:disable_faculty)
      @settings.should respond_to(:disable_faculty=)
    end

    it 'has a Disable Peer Advisors From Making Changes flag (disable_peer_advisors)' do
      @settings.should respond_to(:disable_peer_advisors)
      @settings.should respond_to(:disable_peer_advisors=)
    end
  end

  describe 'Static Attributes' do
    it 'has a Meeting Length (meeting_length)' do
      @settings.meeting_length.should == STATIC_SETTINGS['meeting_length']
    end

    it 'has a Meeting Gap (meeting_gap)' do
      @settings.meeting_gap.should == STATIC_SETTINGS['meeting_gap']
    end
  end

  describe 'Associations' do
    it 'has many Divisions' do
      @settings.should have_many(:divisions)
    end
  end

  describe 'Singleton Model' do
    context 'getting an instance' do
      it 'builds an instance if one does not already exist' do
        Settings.destroy_all
        Settings.count.should == 0
        Settings.instance
        Settings.count.should == 1
      end
 
      it 'returns the existent instance if one exists' do
        Settings.instance.should_not be_a_new_record
      end
    end

    it 'does not otherwise allow a new instance to be created' do
      Settings.should_not respond_to(:new)
    end
  end

  context 'when building' do
    it 'by default has a list of empty Meeting Times per Division' do
      STATIC_SETTINGS['divisions'].each_key do |division_name|
        @settings.meeting_times(division_name).should be_empty
      end
    end

    it 'by default has an Unsatisfied Admit Threshold of 0' do
      @settings.unsatisfied_admit_threshold.should == 0
    end

    it 'by default has a Disable Faculty From Making Changes flag of false' do
      @settings.disable_faculty.should be_false
    end

    it 'by default has a Disable Peer Advisors From Making Changes flag of false' do
      @settings.disable_peer_advisors.should be_false
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @settings.should be_valid
    end

    it 'is not valid with an invalid Unsatisfied Admit Threshold' do
      ['', -1, 'foobar'].each do |invalid_threshold|
        @settings.unsatisfied_admit_threshold = invalid_threshold
        @settings.should_not be_valid
      end
    end

    it 'is not valid without a Disable Faculty From Making Changes flag' do
      @settings.disable_faculty = nil
      @settings.should_not be_valid
    end

    it 'is not valid without a Disable Peer Advisors From Making Changes flag' do
      @settings.disable_peer_advisors = nil
      @settings.should_not be_valid
    end
  end

  context 'when destroying' do
    it 'destroys its Divisions' do
      divisions = Array.new(3) do |i|
        division = Division.new(:name => "Division #{i}")
        division.should_receive(:destroy)
        division
      end
      @settings.stub(:divisions).and_return(divisions)
      @settings.destroy
    end
  end
end
