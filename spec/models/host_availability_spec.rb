require 'spec_helper'

describe HostAvailability do
  before(:each) do
    time_slot = Factory.create(:time_slot)
    faculty = Factory.create(:faculty)
    @host_availability = faculty.availabilities.first
  end

  describe 'Attributes' do
    it 'has a Room (room)' do
      @host_availability.should respond_to(:room)
      @host_availability.should respond_to(:room=)
    end

    it 'has an Available flag (available)' do
      @host_availability.should respond_to(:available)
      @host_availability.should respond_to(:available=)
    end
  end

  describe 'Associations' do
    it 'belongs to a Time Slot (time_slot)' do
      @host_availability.should belong_to(:time_slot)
    end

    it 'belongs to a Host (host)' do
      @host_availability.should belong_to(:host)
    end

    it 'has many Meetings (meetings)' do
      @host_availability.should have_many(:meetings)
    end

    it 'has many Visitors (visitors) through Meetings' do
      @host_availability.should have_many(:visitors).through(:meetings)
    end
  end

  describe 'Scopes' do
    it 'by default is sorted by Time Slot' do
      time = Time.zone.parse('12PM')
      Factory.create(:time_slot, :begin => time, :end => time + 15.minutes)
      @host_availability.time_slot.update_attributes(:begin => time + 15.minutes, :end => time + 30.minutes)
      Factory.create(:time_slot, :begin => time + 30.minutes, :end => time + 45.minutes)
      @host_availability.host.availabilities.reload.map(&:time_slot).map(&:begin).should == [time, time + 15.minutes, time + 30.minutes]
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @host_availability.should be_valid
    end

    it 'is not valid without a Time Slot' do
      @host_availability.time_slot = nil
      @host_availability.should_not be_valid
      @host_availability.errors.full_messages.should include('Time Slot must be specified')
    end

    it 'is not valid without a Host' do
      @host_availability.host = nil
      @host_availability.should_not be_valid
      @host_availability.errors.full_messages.should include('Host must be specified')
    end
  end

  context 'after saving' do
    it 'destroys its Meetings if it is not available' do
      meetings = Array.new(3) {stub_model(Meeting)}
      meetings.should_receive(:destroy_all)
      @host_availability.stub(:meetings).and_return(meetings)
      @host_availability.available = false
      @host_availability.save
    end
  end

  context 'when destroying' do
    it 'destroys its Meetings' do
      meetings = Array.new(3) do
        meeting = stub_model(Meeting)
        meeting.should_receive(:destroy)
        meeting
      end
      @host_availability.stub(:meetings).and_return(meetings)
      @host_availability.destroy
    end
  end
end
