require 'spec_helper'

describe Meeting do
  before(:each) do
    @meeting = Factory.create(:meeting)
  end

  describe 'Attributes' do
    it 'has a Time (time)' do
      @meeting.should respond_to(:time)
      @meeting.should respond_to(:time=)
    end

    it 'has a Room (room)' do
      @meeting.should respond_to(:room)
      @meeting.should respond_to(:room=)
    end
  end

  describe 'Associations' do
    it 'belongs to a Faculty (faculty)' do
      @meeting.should belong_to(:faculty)
    end

    it 'has and belongs to many Admits' do
      @meeting.should have_and_belong_to_many(:admits)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @meeting.should be_valid
    end

    it 'is not valid with an invalid time' do
      ['', 'foobar'].each do |invalid_time|
        @meeting.time = invalid_time
        @meeting.should_not be_valid
      end
    end

    it 'is not valid without a room' do
      @meeting.room = ''
      @meeting.should_not be_valid
    end

    it 'is not valid without a Faculty' do
      @meeting.faculty = nil
      @meeting.should_not be_valid
    end

    it 'is not valid with an invalid Faculty' do
      @meeting.faculty.destroy
      @meeting.should_not be_valid
    end
  end

  describe 'Conflict' do
    context 'for faculty' do
      before(:each) do
        @faculty = Factory.create(:faculty)
        @meeting.faculty = @faculty
        @time = Time.parse("11:00")
        @meeting.time = @time
        @meeting.save!
      end
      it 'occurs if faculty already has a 1-on-1 meeting during same time slot' do
        @ranking = Factory.create(:admit_ranking, :faculty => @faculty, :one_on_one => true)
        @meeting.admits = [@ranking.admit]
        @meeting.save!
        @new = Factory.create(:meeting, :time => @time, :faculty => Factory.create(:faculty))
        @new.should_not be_valid
        @new.errors.full_messages.should include("#{@faculty.full_name} has a 1-on-1 meeting with #{@meeting.admit.full_name} at 11:00.")
      end
      it 'occurs if faculty has max number of admits scheduled during same time slot'
      it 'occurs if faculty is unavailable during that time slot'
    end
    context 'for admit' do
      it 'occurs if admit is already scheduled with another faculty during same time slot'
      it 'occurs if admit is unavailable during time slot'
    end
    it 'occurs if time slot has not been marked as Available by staff'
    it 'does not occur if there is no conflict with staff times, with faculty, or with admit'
  end
end
