require 'spec_helper'

describe Division do
  before(:each) do
    settings = Settings.instance
    @division = settings.divisions.create(:name => 'Name')
  end

  describe 'Attributes' do
    it 'has a Name (name)' do
      @division.should respond_to(:name)
      @division.should respond_to(:name=)
    end

    it 'has an attribute name to accessor map' do
      Division::ATTRIBUTES['Name'].should == :name
    end

    it 'has an accessor to type map' do
      Division::ATTRIBUTE_TYPES[:name].should == :string
    end
  end

  describe 'Associations' do
    it 'has many Available Meeting Times (available_times)' do
      @division.should have_many(:available_times)
    end

    it 'belongs to Settings (settings)' do
      @division.should belong_to(:settings)
    end
  end

  describe 'Nested Attributes' do
    describe 'Available Times (available_times)' do
      it 'allows nested attributes for Available Times (available_times)' do
        attributes = {:available_times_attributes => [
          {:begin => Time.zone.parse('1/1/2011'), :end => Time.zone.parse('1/2/2011')},
          {:begin => Time.zone.parse('1/3/2011'), :end => Time.zone.parse('1/4/2011')}
        ]}
        @division.attributes = attributes
        @division.available_times.each_with_index do |time, i|
          time.begin.should == attributes[:available_times_attributes][i][:begin]
          time.end.should == attributes[:available_times_attributes][i][:end]
        end
      end
  
      it 'ignores completely blank entries' do
        attributes = {:available_times_attributes => [
          {:begin => Time.zone.parse('1/1/2011'), :end => Time.zone.parse('1/2/2011')},
          {:begin => '', :end => ''}
        ]}
        @division.attributes = attributes
        @division.available_times.length.should == 1
      end

      it 'allows deletion' do
        attributes = {:available_times_attributes => [
          {:begin => Time.zone.parse('1/1/2011'), :end => Time.zone.parse('1/2/2011')},
        ]}
        @division.attributes = attributes
        @division.save

        new_attributes = {:available_times_attributes => [
          {:id => @division.available_times.first.id, :_destroy => true},
        ]}
        @division.attributes = new_attributes
        @division.available_times.first.should be_marked_for_destruction
      end
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @division.should be_valid
    end

    it 'is valid with valid non-overlapping Available Meeting Times' do
      [
        [
          AvailableTime.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          AvailableTime.new(:begin => Time.zone.parse('1/8/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          AvailableTime.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/6/2011')),
          AvailableTime.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |times|
        @division.available_times = times
        @division.should be_valid
      end
    end

    it 'is not valid with invalid Available Meeting Times' do
      @division.available_times.build
      @division.should_not be_valid
    end

    it 'is not valid with overlapping Available Meeting Times' do
      [
        [
          AvailableTime.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          AvailableTime.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/8/2011'))
        ],
        [
          AvailableTime.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          AvailableTime.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          AvailableTime.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          AvailableTime.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |times|
        @division.available_times = times
        @division.should_not be_valid
      end
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
    it 'destroys its Available Times' do
      available_times = Array.new(3) do |i|
        available_time = AvailableTime.create(
          :begin => Time.zone.parse("1:00PM 1/#{i + 1}/2011"),
          :end => Time.zone.parse("5:00PM 1/#{i + 1}/2011")
        )
        available_time.should_receive(:destroy)
        available_time
      end
      @division.stub(:available_times).and_return(available_times)
      @division.destroy
    end
  end
end
