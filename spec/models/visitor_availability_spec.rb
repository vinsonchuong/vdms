require 'spec_helper'

describe VisitorAvailability do
  before(:each) do
    time_slot = Factory.create(:time_slot)
    visitor = Factory.create(:visitor)
    @visitor_availability = visitor.availabilities.first
  end

  describe 'Attributes' do
    it 'has an Available flag (available)' do
      @visitor_availability.should respond_to(:available)
      @visitor_availability.should respond_to(:available=)
    end
  end

  describe 'Associations' do
    it 'belongs to a Time Slot (time_slot)' do
      @visitor_availability.should belong_to(:time_slot)
    end

    it 'belongs to a Visitor (visitor)' do
      @visitor_availability.should belong_to(:visitor)
    end

    it 'has many Meetings (meetings)' do
      @visitor_availability.should have_many(:meetings)
    end
  end

  describe 'Scopes' do
    it 'by default is sorted by Time Slot' do
      time = Time.zone.parse('12PM')
      Factory.create(:time_slot, :begin => time, :end => time + 15.minutes)
      @visitor_availability.time_slot.update_attributes(:begin => time + 15.minutes, :end => time + 30.minutes)
      Factory.create(:time_slot, :begin => time + 30.minutes, :end => time + 45.minutes)
      @visitor_availability.visitor.availabilities.reload.map(&:time_slot).map(&:begin).should == [time, time + 15.minutes, time + 30.minutes]
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @visitor_availability.should be_valid
    end

    it 'is not valid without a Time Slot' do
      @visitor_availability.time_slot = nil
      @visitor_availability.should_not be_valid
      @visitor_availability.errors.full_messages.should include('Time Slot must be specified')
    end

    it 'is not valid without a Visitor' do
      @visitor_availability.visitor = nil
      @visitor_availability.should_not be_valid
      @visitor_availability.errors.full_messages.should include('Visitor must be specified')
    end
  end

  context 'after saving' do
    it 'destroys its Meetings if it is not available' do
      meetings = Array.new(3) {stub_model(Meeting)}
      meetings.should_receive(:destroy_all)
      @visitor_availability.stub(:meetings).and_return(meetings)
      @visitor_availability.available = false
      @visitor_availability.save
    end
  end

  context 'when destroying' do
    it 'destroys its Meetings' do
      meetings = Array.new(3) do
        meeting = stub_model(Meeting)
        meeting.should_receive(:destroy)
        meeting
      end
      @visitor_availability.stub(:meetings).and_return(meetings)
      @visitor_availability.destroy
    end
  end
end
