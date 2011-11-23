require 'spec_helper'

describe VisitorAvailability do
  before(:each) do
    @event = Factory.create(:event)
    Factory.create(:time_slot, :event => @event)
    visitor = Factory.create(:visitor, :event => @event)
    @availability = visitor.availabilities.first
  end

  describe 'Attributes' do
    it 'has an Available flag (available)' do
      @availability.should respond_to(:available)
      @availability.should respond_to(:available=)
    end
  end

  describe 'Associations' do
    it 'belongs to a Time Slot (time_slot)' do
      @availability.should belong_to(:time_slot)
    end

    it 'belongs to a Visitor (schedulable)' do
      @availability.should belong_to(:schedulable)
    end

    it 'has many Meetings (meetings)' do
      @availability.should have_many(:meetings)
    end
  end

  describe 'Scopes' do
    it 'by default is sorted by Time Slot' do
      time = Time.zone.parse('12PM')
      Factory.create(:time_slot, :begin => time, :end => time + 15.minutes, :event => @event)
      @availability.time_slot.update_attributes(:begin => time + 15.minutes, :end => time + 30.minutes)
      Factory.create(:time_slot, :begin => time + 30.minutes, :end => time + 45.minutes, :event => @event)
      @availability.schedulable.availabilities.reload.map(&:time_slot).map(&:begin).should == [time, time + 15.minutes, time + 30.minutes]
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @availability.should be_valid
    end

    it 'is not valid without a Time Slot' do
      pending
      @availability.time_slot = nil
      @availability.should_not be_valid
      @availability.errors.full_messages.should include('Time Slot must be specified')
    end

    it 'is not valid without a Visitor' do
      pending
      @availability.schedulable = nil
      @availability.should_not be_valid
      @availability.errors.full_messages.should include('Visitor must be specified')
    end
  end

  context 'after saving' do
    it 'destroys its Meetings if it is not available' do
      meetings = Array.new(3) {stub_model(Meeting)}
      meetings.should_receive(:destroy_all)
      @availability.stub(:meetings).and_return(meetings)
      @availability.available = false
      @availability.save
    end
  end

  context 'when destroying' do
    it 'destroys its Meetings' do
      3.times do
        meeting = mock_model(Meeting).as_null_object
        meeting.should_receive(:destroy)
        @availability.meetings << meeting
      end
      @availability.destroy
    end
  end
end
