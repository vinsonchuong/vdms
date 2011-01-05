require 'spec_helper'

describe Meeting do
  describe 'Attributes' do
    before(:each) do
      @meeting = Meeting.new
    end

    it 'has a Time (time)' do
      @meeting.should respond_to(:time)
      @meeting.should respond_to(:time=)
    end

    it 'has a Room (room)' do
      @meeting.should respond_to(:room)
      @meeting.should respond_to(:room=)
    end
  end

  it 'has an attribute name to accessor map' do
    Meeting::ATTRIBUTES['Time'].should == :time
    Meeting::ATTRIBUTES['Room'].should == :room
  end

  describe 'Associations' do
    before(:each) do
      @meeting = Meeting.new
    end

    it 'belongs to a faculty (faculty)' do
      @meeting.should belong_to(:faculty)
    end

    it 'has and belongs to many admits' do
      @meeting.should have_and_belong_to_many(:admits)
    end
  end
end
