require 'spec_helper'

describe Meeting do
  before(:each) do
    @start_time = Time.zone.parse('5PM')
    @end_time = @start_time + 15.minutes
    @meeting = Factory.create(:meeting)
    @meeting.host_time_slot.update_attributes({:begin => @start_time, :end => @end_time})
    @meeting.visitor_time_slot.update_attributes({:begin => @start_time, :end => @end_time})
  end

  describe 'Associations' do
    it "belongs to a Host's Time Slot (host_time_slot)" do
      @meeting.should belong_to(:host_time_slot)
    end

    it "belongs to a Visitor's Time Slot (visitor_time_slot)" do
      @meeting.should belong_to(:visitor_time_slot)
    end
  end

  describe 'Virtual Attributes' do
    it 'has a Host (host)' do
      @meeting.host_time_slot.stub(:host).and_return('Host')
      @meeting.host.should == 'Host'
    end

    it 'has a Visitor (visitor)' do
      @meeting.visitor_time_slot.stub(:visitor).and_return('Visitor')
      @meeting.visitor.should == 'Visitor'
    end

    it 'has a Room (room)' do
      @meeting.host_time_slot.stub(:room).and_return('Room')
      @meeting.room.should == 'Room'
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @meeting.should be_valid
    end

    it 'is not valid with Time Slots representing different times' do
      @meeting.host_time_slot.begin += 30.minutes
      @meeting.host_time_slot.end += 30.minutes
      @meeting.should_not be_valid
      @meeting.errors.full_messages.should include('Time slots must match')
    end

    it 'is not valid with a Host who is unavailable during the Time Slot' do
      @meeting.host_time_slot.available = false
      @meeting.should_not be_valid
      @meeting.errors.full_messages.should include('First Last is not available from 05:00PM to 05:15PM')
    end

    it 'is not valid with a Visitor who is unavailable during the Time Slot' do
      @meeting.visitor_time_slot.visitor.stub(:full_name).and_return('Visitor')
      @meeting.visitor_time_slot.available = false
      @meeting.should_not be_valid
      @meeting.errors.full_messages.should include('First Last is not available from 05:00PM to 05:15PM')
    end

    it 'is not valid when the Host is already meeting with his maximum number of Visitors for the Time Slot' do
      @meeting.host.update_attribute(:max_admits_per_meeting, 2)
      visitor2 = Factory.create(:admit)
      visitor2_time_slot = visitor2.time_slots.create(:begin => @start_time, :end => @end_time, :available => true)
      meeting2 = Meeting.create(:host_time_slot => @meeting.host_time_slot, :visitor_time_slot => visitor2_time_slot)
      visitor3 = Factory.create(:admit)
      visitor3_time_slot = visitor3.time_slots.create(:begin => @start_time, :end => @end_time, :available => true)
      meeting3 = Meeting.new(:host_time_slot => @meeting.host_time_slot, :visitor_time_slot => visitor3_time_slot)
      meeting3.should_not be_valid
      meeting3.errors.full_messages.should include('First Last is already meeting with his/her max of 2 visitors')
    end

    it 'is not valid when the Visitor is already meeting with a Host at the Time Slot' do
      host2 = Factory.create(:faculty)
      host2_time_slot = host2.time_slots.create(:begin => @start_time, :end => @end_time, :available => true)
      meeting2 = host2_time_slot.meetings.build(:visitor_time_slot => @meeting.visitor_time_slot)
      meeting2.should_not be_valid
      meeting2.errors.full_messages.should include('First Last is already meeting with First Last from 05:00PM to 05:15PM')
    end
  end

  context 'after creating' do
    it 'has consistent associations' do
      host_time_slot = @meeting.host_time_slot
      host = host_time_slot.host
      visitor_time_slot = @meeting.visitor_time_slot
      visitor = visitor_time_slot.visitor

      start_time2 = @start_time + 15.minutes
      end_time2 = @end_time + 15.minutes
      host_time_slot2 = host.time_slots.create!(:begin => start_time2, :end => end_time2, :available => true)
      visitor_time_slot2 = visitor.time_slots.create!(:begin => start_time2, :end => end_time2, :available => true)
      meeting2 = host_time_slot2.meetings.create!(:visitor_time_slot => visitor_time_slot2)
      host.meetings.should include(meeting2)
      visitor_time_slot2.meetings.should include(meeting2)
      visitor.meetings.should include(meeting2)

      visitor2_time_slot = Factory.create(:visitor_time_slot, :begin => @start_time, :end => @end_time)
      meeting3 = visitor2_time_slot.meetings.create(:host_time_slot => host_time_slot)
      host_time_slot.meetings.should include(meeting3)
      host.meetings.should include(meeting3)
      visitor2_time_slot.visitor.meetings.should include(meeting3)

      host2_time_slot = Factory.create(:host_time_slot, :begin => @start_time, :end => @end_time)
      visitor3_time_slot = Factory.create(:visitor_time_slot, :begin => @start_time, :end => @end_time)
      meeting4 = Meeting.create(:host_time_slot => host2_time_slot, :visitor_time_slot => visitor3_time_slot)
      host2_time_slot.meetings.should include(meeting4)
      host2_time_slot.host.meetings.should include(meeting4)
      visitor3_time_slot.meetings.should include(meeting4)
      visitor3_time_slot.visitor.meetings.should include(meeting4)
    end
  end

  context 'after deleting' do
    it 'has consistent associations' do
      host_time_slot = @meeting.host_time_slot
      visitor_time_slot = @meeting.visitor_time_slot
      @meeting.destroy
      host_time_slot.meetings.should_not include(@meeting)
      host_time_slot.host.meetings.should_not include(@meeting)
      visitor_time_slot.meetings.should_not include(@meeting)
      visitor_time_slot.visitor.meetings.should_not include(@meeting)
    end
  end
end
