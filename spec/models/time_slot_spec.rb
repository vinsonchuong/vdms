require 'spec_helper'

describe TimeSlot do
  before(:each) do
    @time_slot = Factory.create(:time_slot)
  end

  describe 'Attributes' do
    it 'has a Start Time (begin)' do
      @time_slot.should respond_to(:begin)
      @time_slot.should respond_to(:begin=)
    end

    it 'has an End Time (end)' do
      @time_slot.should respond_to(:end)
      @time_slot.should respond_to(:end=)
    end

    it 'has a Room (room)' do
      @time_slot.should respond_to(:room)
      @time_slot.should respond_to(:room=)
    end

    it 'has an Available flag (available)' do
      @time_slot.should respond_to(:available)
      @time_slot.should respond_to(:available=)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @time_slot.should be_valid
    end

    it 'is valid with a valid Start Time' do
      [@time_slot.begin, @time_slot.begin.to_s].each do |t|
        @time_slot.begin = t
        @time_slot.should be_valid
      end
    end

    it 'is valid with a valid End Time' do
      [@time_slot.end, @time_slot.end.to_s].each do |t|
        @time_slot.end = t
        @time_slot.should be_valid
      end
    end

    it 'is not valid without a Start Time' do
      ['', nil].each do |invalid_time|
        @time_slot.begin = invalid_time
        @time_slot.should_not be_valid
        @time_slot.errors.full_messages.should include("Start Time can't be blank")
      end
    end

    it 'is not valid with an invalid Start Time' do
      ['foobar'].each do |invalid_time|
        @time_slot.begin = invalid_time
        @time_slot.should_not be_valid
        @time_slot.errors.full_messages.should include('Start Time is not a valid datetime')
      end
    end

    it 'is not valid without an End Time' do
      ['', nil].each do |invalid_time|
        @time_slot.end = invalid_time
        @time_slot.should_not be_valid
        @time_slot.errors.full_messages.should include("End Time can't be blank")
      end
    end

    it 'is not valid with an invalid End Time' do
      ['foobar'].each do |invalid_time|
        @time_slot.end = invalid_time
        @time_slot.should_not be_valid
        @time_slot.errors.full_messages.should include('End Time is not a valid datetime')
      end
    end

    it 'is not valid with an End Time not following the Start Time' do
      @time_slot.begin = Time.zone.parse('1/5/2011')
      @time_slot.end = Time.zone.parse('1/4/2011')
      @time_slot.should_not be_valid
      @time_slot.errors.full_messages.should include('End Time must be after 2011-01-05 00:00:00')
    end
  end

  context 'when determining whether a Time Slot overlaps with another' do
    it 'returns true when they overlap' do
      [
        [
          Factory.build(:time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:time_slot, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/8/2011'))
        ],
        [
          Factory.build(:time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:time_slot, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          Factory.build(:time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:time_slot, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |x, y|
        x.overlap?(y).should be_true
        y.overlap?(x).should be_true
      end
    end

    it 'returns false when they do not overlap' do
      [
        [
          Factory.build(:time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:time_slot, :begin => Time.zone.parse('1/8/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          Factory.build(:time_slot, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/6/2011')),
          Factory.build(:time_slot, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |x, y|
        x.overlap?(y).should be_false
        y.overlap?(x).should be_false
      end
    end
  end
end
