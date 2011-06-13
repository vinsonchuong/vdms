require 'spec_helper'

describe Division do
  before(:each) do
    settings = Settings.instance
    @division = settings.divisions.create(:name => STATIC_SETTINGS['divisions'].keys.first)
  end

  describe 'Attributes' do
    it 'has a Name (name)' do
      @division.should respond_to(:name)
      @division.should respond_to(:name=)
    end
  end

  describe 'Virtual Attributes' do
    it 'has a Long Name (long_name)' do
      @division.long_name.should == STATIC_SETTINGS['divisions'][@division.name]
    end
  end

  describe 'Associations' do
    describe 'Time Slots' do
      it 'has many Time Slots (time_slots)' do
        @division.should have_many(:time_slots)
      end

      it 'has many Time Slots sorted by Start Time' do
        @division.time_slots.create(:begin => Time.zone.parse('1/4/2011'), :end => Time.zone.parse('1/5/2011'))
        @division.time_slots.create(:begin => Time.zone.parse('1/3/2011'), :end => Time.zone.parse('1/4/2011'))
        @division.time_slots.create(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        @division.time_slots.reload.map {|t| t.attributes['begin']}.should == [
          Time.zone.parse('1/3/2011'),
          Time.zone.parse('1/4/2011'),
          Time.zone.parse('1/6/2011'),
        ]
      end
    end

    it 'belongs to Settings (settings)' do
      @division.should belong_to(:settings)
    end
  end

  describe 'Nested Attributes' do
    describe 'Time Slots (time_slots)' do
      it 'allows nested attributes for Time Slots (time_slots)' do
        attributes = {:time_slots_attributes => [
          {:begin => Time.zone.parse('1/1/2011'), :end => Time.zone.parse('1/2/2011')},
          {:begin => Time.zone.parse('1/3/2011'), :end => Time.zone.parse('1/4/2011')}
        ]}
        @division.attributes = attributes
        @division.time_slots.each_with_index do |time, i|
          time.begin.should == attributes[:time_slots_attributes][i][:begin]
          time.end.should == attributes[:time_slots_attributes][i][:end]
        end
      end
  
      it 'ignores completely blank entries' do
        attributes = {:time_slots_attributes => [
          {:begin => Time.zone.parse('1/1/2011'), :end => Time.zone.parse('1/2/2011')},
          {:begin => '', :end => ''}
        ]}
        @division.attributes = attributes
        @division.time_slots.length.should == 1
      end

      it 'allows deletion' do
        attributes = {:time_slots_attributes => [
          {:begin => Time.zone.parse('1/1/2011'), :end => Time.zone.parse('1/2/2011')}
        ]}
        @division.attributes = attributes
        @division.save

        new_attributes = {:time_slots_attributes => [
          {:id => @division.time_slots.first.id, :_destroy => true},
        ]}
        @division.attributes = new_attributes
        @division.time_slots.first.should be_marked_for_destruction
      end
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @division.should be_valid
    end

    it 'is not valid without a Name' do
      @division.name = ''
      @division.should_not be_valid
    end

    it 'is valid with valid non-overlapping Available Meeting Times' do
      [
        [
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/8/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/6/2011')),
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |times|
        @division.time_slots = times
        @division.should be_valid
      end
    end

    it 'is not valid with invalid Available Meeting Times' do
      @division.time_slots.build
      @division.should_not be_valid
    end

    it 'is not valid with overlapping Available Meeting Times' do
      [
        [
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/8/2011'))
        ],
        [
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          DivisionTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |times|
        @division.time_slots = times
        @division.should_not be_valid
      end
    end

    it 'is valid with overlapping Time Slots that are marked for destruction' do
      time1 = DivisionTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011'))
      time2 = DivisionTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/8/2011'))
      time3 = DivisionTimeSlot.new(:begin => Time.zone.parse('1/7/2011'), :end => Time.zone.parse('1/9/2011'))
      @division.time_slots = [time1, time2, time3]
      time1.mark_for_destruction
      time2.mark_for_destruction
      @division.should be_valid
    end

    it 'is not valid if it is not owned by a Settings' do
      @division.settings = nil
      @division.should_not be_valid
    end

    it 'is not valid if it is not owned by a valid Settings' do
      @division.settings.destroy
      @division.should_not be_valid
    end
  end

  context 'when destroying' do
    it 'destroys its Time Slots' do
      time_slots = Array.new(3) do |i|
        time_slot = TimeSlot.create(
          :begin => Time.zone.parse("1:00PM 1/#{i + 1}/2011"),
          :end => Time.zone.parse("5:00PM 1/#{i + 1}/2011")
        )
        time_slot.should_receive(:destroy)
        time_slot
      end
      @division.stub(:time_slots).and_return(time_slots)
      @division.destroy
    end
  end
end
