require 'spec_helper'

describe Meeting do
  before(:each) do
    @time_slot = Factory.create(:time_slot, :begin => Time.zone.parse('5PM'), :end => Time.zone.parse('5:15PM'))
    host_availability = Factory.create(:host_availability, :time_slot => @time_slot)
    visitor_availability = Factory.create(:visitor_availability, :time_slot => @time_slot)
    @meeting = Meeting.create(:host_availability => host_availability, :visitor_availability => visitor_availability)
  end

  describe 'Associations' do
    it "belongs to a Host's Time Slot (host_availability)" do
      @meeting.should belong_to(:host_availability)
    end

    it "belongs to a Visitor's Time Slot (visitor_availability)" do
      @meeting.should belong_to(:visitor_availability)
    end
  end

  describe 'Virtual Attributes' do
    it 'has a Host (host)' do
      @meeting.host_availability.stub(:host).and_return('Host')
      @meeting.host.should == 'Host'
    end

    it 'has a Visitor (visitor)' do
      @meeting.visitor_availability.stub(:visitor).and_return('Visitor')
      @meeting.visitor.should == 'Visitor'
    end

    it 'has a Room (room)' do
      @meeting.host_availability.stub(:room).and_return('Room')
      @meeting.room.should == 'Room'
    end
  end

  describe 'Scopes' do
    it "sorts by Host's name" do
      @meeting.host.person.update_attributes(:first_name => 'Bbb', :last_name => 'Bbb')
      visitor_availability2 = Factory.create(:visitor_availability, :time_slot => @time_slot)
      Meeting.create(:host_availability => @meeting.host_availability, :visitor_availability => visitor_availability2)
      host2 = Factory.create(:host, :person => Factory.create(:faculty, :first_name => 'Aaa', :last_name => 'Aaa'))
      host_availability2 = Factory.create(:host_availability, :host => host2, :time_slot => @time_slot)
      visitor_availability3 = Factory.create(:visitor_availability, :time_slot => @time_slot)
      Meeting.create(:host_availability => host_availability2, :visitor_availability => visitor_availability3)
      Meeting.by_host.map {|m| m.host.person.name}.should == ['Aaa Aaa', 'Bbb Bbb', 'Bbb Bbb']
    end

    it "sorts by Visitor's name" do
      @meeting.visitor.person.update_attributes(:first_name => 'Bbb', :last_name => 'Bbb')
      visitor2 = Factory.create(:visitor, :person => Factory.create(:admit, :first_name => 'Aaa', :last_name => 'Aaa'))
      visitor_availability2 = Factory.create(:visitor_availability, :visitor => visitor2, :time_slot => @time_slot)
      host_availability2 = Factory.create(:host_availability, :time_slot => @time_slot)
      Meeting.create(:host_availability => host_availability2, :visitor_availability => visitor_availability2)
      Meeting.by_visitor.map {|m| m.visitor.person.name}.should == ['Aaa Aaa', 'Bbb Bbb']
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @meeting.should be_valid
    end

    it 'is not valid with Time Slots representing different times' do
      @meeting.host_availability.time_slot.stub(:==).and_return(false)
      @meeting.should_not be_valid
      @meeting.errors.full_messages.should include('Time slots must match')
    end

    it 'is not valid with a Host who is unavailable during the Time Slot' do
      @meeting.host_availability.available = false
      @meeting.should_not be_valid
      @meeting.errors.full_messages.should include('First Last is not available from 05:00PM to 05:15PM')
    end

    it 'is not valid with a Visitor who is unavailable during the Time Slot' do
      @meeting.visitor_availability.visitor.stub(:full_name).and_return('Visitor')
      @meeting.visitor_availability.available = false
      @meeting.should_not be_valid
      @meeting.errors.full_messages.should include('First Last is not available from 05:00PM to 05:15PM')
    end

    it 'is not valid when the Host is already meeting with his maximum number of Visitors for the Time Slot' do
      @meeting.host.update_attribute(:max_visitors_per_meeting, 2)
      visitor2 = Factory.create(:visitor)
      visitor2_availability = visitor2.availabilities.create(:time_slot => @time_slot, :available => true)
      meeting2 = Meeting.create(:host_availability => @meeting.host_availability, :visitor_availability => visitor2_availability)
      visitor3 = Factory.create(:visitor)
      visitor3_availability = visitor3.availabilities.create(:time_slot => @time_slot, :available => true)
      meeting3 = Meeting.new(:host_availability => @meeting.host_availability, :visitor_availability => visitor3_availability)
      meeting3.should_not be_valid
      meeting3.errors.full_messages.should include('First Last is already meeting with his/her max of 2 visitors')
    end

    it 'is not valid when the Visitor is already meeting with a Host at the Time Slot' do
      host2_availability = Factory.create(:host_availability)
      meeting2 = host2_availability.meetings.build(:visitor_availability => @meeting.visitor_availability)
      meeting2.should_not be_valid
      meeting2.errors.full_messages.should include('First Last is already meeting with First Last from 05:00PM to 05:15PM')
    end
  end

  context 'after creating' do
    it 'has consistent associations' do
      host_availability = @meeting.host_availability
      host = host_availability.host
      visitor_availability = @meeting.visitor_availability
      visitor = visitor_availability.visitor

      time_slot2 = Factory.create(:time_slot)
      host_availability2 = host.availabilities.create!(:time_slot => time_slot2, :available => true)
      visitor_availability2 = visitor.availabilities.create!(:time_slot => time_slot2, :available => true)
      meeting2 = host_availability2.meetings.create!(:visitor_availability => visitor_availability2)
      host.meetings.should include(meeting2)
      visitor_availability2.meetings.should include(meeting2)
      visitor.meetings.should include(meeting2)

      visitor2_availability = Factory.create(:visitor_availability, :time_slot => @time_slot)
      meeting3 = visitor2_availability.meetings.create(:host_availability => host_availability)
      host_availability.meetings.should include(meeting3)
      host.meetings.should include(meeting3)
      visitor2_availability.visitor.meetings.should include(meeting3)

      host2_availability = Factory.create(:host_availability, :time_slot => @time_slot)
      visitor3_availability = Factory.create(:visitor_availability, :time_slot => @time_slot)
      meeting4 = Meeting.create(:host_availability => host2_availability, :visitor_availability => visitor3_availability)
      host2_availability.meetings.should include(meeting4)
      host2_availability.host.meetings.should include(meeting4)
      visitor3_availability.meetings.should include(meeting4)
      visitor3_availability.visitor.meetings.should include(meeting4)
    end
  end

  context 'after deleting' do
    it 'has consistent associations' do
      host_availability = @meeting.host_availability
      visitor_availability = @meeting.visitor_availability
      @meeting.destroy
      host_availability.meetings.should_not include(@meeting)
      host_availability.host.meetings.should_not include(@meeting)
      visitor_availability.meetings.should_not include(@meeting)
      visitor_availability.visitor.meetings.should_not include(@meeting)
    end
  end
end
