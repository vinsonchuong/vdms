require 'spec_helper'

describe Meeting do
  describe 'Attributes' do
    before(:each) do
      @meeting = Meeting.new
    end

    it 'has a time (time)' do
      @meeting.should respond_to(:time)
      @meeting.should respond_to(:time=)
    end

    it 'has a room (room)' do
      @meeting.should respond_to(:room)
      @meeting.should respond_to(:room=)
    end
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
