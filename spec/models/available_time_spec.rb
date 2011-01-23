require 'spec_helper'

describe AvailableTime do
  before(:each) do
    @available_time = Factory.create(:available_time)
  end

  describe 'Attributes' do
    it 'has a Beginning (begin)' do
      @available_time.should respond_to(:begin)
      @available_time.should respond_to(:begin=)
    end

    it 'has an End (end)' do
      @available_time.should respond_to(:end)
      @available_time.should respond_to(:end=)
    end

    it 'has a Room (room)' do
      @available_time.should respond_to(:room)
      @available_time.should respond_to(:room=)
    end

    it 'has an attribute name to accessor map' do
      AvailableTime::ATTRIBUTES['Beginning'].should == :begin
      AvailableTime::ATTRIBUTES['End'].should == :end
      AvailableTime::ATTRIBUTES['Room'].should == :room
    end

    it 'has an accessor to type map' do
      AvailableTime::ATTRIBUTE_TYPES[:begin].should == :time
      AvailableTime::ATTRIBUTE_TYPES[:end].should == :time
      AvailableTime::ATTRIBUTE_TYPES[:room].should == :string
    end
  end

  describe 'Associations' do
    it 'belongs to a Person (person)' do
      @available_time.should belong_to(:schedulable)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @available_time.should be_valid
    end

    it 'is not valid with an invalid Beginning' do
      ['', 'foobar'].each do |invalid_time|
        @available_time.begin = invalid_time
        @available_time.should_not be_valid
      end
    end

    it 'is not valid with an invalid End' do
      ['', 'foobar'].each do |invalid_time|
        @available_time.end = invalid_time
        @available_time.should_not be_valid
      end
    end

    it 'is not valid with an End that precedes the Beginning' do
      @available_time.begin = Time.zone.parse('1/5/2011')
      @available_time.end = Time.zone.parse('1/4/2011')
      @available_time.should_not be_valid
    end

    it 'is not valid without an owner (schedulable)' do
      @available_time.schedulable = nil
      @available_time.should_not be_valid
    end

    it 'is not valid with an invalid owner (schedulable)' do
      @available_time.schedulable.destroy
      @available_time.should_not be_valid
    end
  end

  context 'when determining whether an Available Time overlaps with another' do
    it 'returns true when they overlap' do
      [
        [
          Factory.build(:available_time, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:available_time, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/8/2011'))
        ],
        [
          Factory.build(:available_time, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:available_time, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          Factory.build(:available_time, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:available_time, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |x, y|
        x.overlap?(y).should be_true
        y.overlap?(x).should be_true
      end
    end

    it 'returns false when they do not overlap' do
      [
        [
          Factory.build(:available_time, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          Factory.build(:available_time, :begin => Time.zone.parse('1/8/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          Factory.build(:available_time, :begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/6/2011')),
          Factory.build(:available_time, :begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |x, y|
        x.overlap?(y).should be_false
        y.overlap?(x).should be_false
      end
    end
  end
end
