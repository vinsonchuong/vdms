require 'spec_helper'

describe HostTimeSlot do
  before(:each) do
    @host_time_slot = Factory.create(:host_time_slot)
  end

  describe 'Attributes' do
    it 'has a Start Time (begin)' do
      @host_time_slot.should respond_to(:begin)
      @host_time_slot.should respond_to(:begin=)
    end

    it 'has an End Time (end)' do
      @host_time_slot.should respond_to(:end)
      @host_time_slot.should respond_to(:end=)
    end

    it 'has a Room (room)' do
      @host_time_slot.should respond_to(:room)
      @host_time_slot.should respond_to(:room=)
    end

    it 'has an Available flag (available)' do
      @host_time_slot.should respond_to(:available)
      @host_time_slot.should respond_to(:available=)
    end
  end

  describe 'Associations' do
    it 'belongs to a Host (host)' do
      @host_time_slot.should belong_to(:host)
    end

    it 'has many Meetings (meetings)' do
      @host_time_slot.should have_many(:meetings)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @host_time_slot.should be_valid
    end

    it 'is valid with a valid Start Time' do
      [@host_time_slot.begin, @host_time_slot.begin.to_s].each do |t|
        @host_time_slot.begin = t
        @host_time_slot.should be_valid
      end
    end

    it 'is valid with a valid End Time' do
      [@host_time_slot.end, @host_time_slot.end.to_s].each do |t|
        @host_time_slot.end = t
        @host_time_slot.should be_valid
      end
    end

    it 'is not valid without a Start Time' do
      ['', nil].each do |invalid_time|
        @host_time_slot.begin = invalid_time
        @host_time_slot.should_not be_valid
        @host_time_slot.errors.full_messages.should include("Start Time can't be blank")
      end
    end

    it 'is not valid with an invalid Start Time' do
      ['foobar'].each do |invalid_time|
        @host_time_slot.begin = invalid_time
        @host_time_slot.should_not be_valid
        @host_time_slot.errors.full_messages.should include('Start Time is not a valid datetime')
      end
    end

    it 'is not valid without an End Time' do
      ['', nil].each do |invalid_time|
        @host_time_slot.end = invalid_time
        @host_time_slot.should_not be_valid
        @host_time_slot.errors.full_messages.should include("End Time can't be blank")
      end
    end

    it 'is not valid with an invalid End Time' do
      ['foobar'].each do |invalid_time|
        @host_time_slot.end = invalid_time
        @host_time_slot.should_not be_valid
        @host_time_slot.errors.full_messages.should include('End Time is not a valid datetime')
      end
    end

    it 'is not valid with an End Time not following the Start Time' do
      @host_time_slot.begin = Time.zone.parse('1/5/2011')
      @host_time_slot.end = Time.zone.parse('1/4/2011')
      @host_time_slot.should_not be_valid
      @host_time_slot.errors.full_messages.should include('End Time must be after 2011-01-05 00:00:00')
    end

    it 'is not valid without a Host' do
      @host_time_slot.host = nil
      @host_time_slot.should_not be_valid
      @host_time_slot.errors.full_messages.should include('Host must be specified')
    end
  end

  context 'when determining whether a Time Slot overlaps with another' do
    it 'returns true when they overlap' do
      [
        [
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/8/2011'))
        ],
        [
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |x, y|
        x.overlap?(y).should be_true
        y.overlap?(x).should be_true
      end
    end

    it 'returns false when they do not overlap' do
      [
        [
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/8/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/6/2011')),
          Factory.build(:host_time_slot, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |x, y|
        x.overlap?(y).should be_false
        y.overlap?(x).should be_false
      end
    end
  end

  context 'when destroying' do
    it 'destroys its Meetings' do
      meetings = Array.new(3) do |i|
        meeting = Factory.create(:meeting)
        meeting.should_receive(:destroy)
        meeting
      end
      @host_time_slot.stub(:meetings).and_return(meetings)
      @host_time_slot.destroy
    end
  end
end
