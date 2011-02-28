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
    def make_one_on_one_meeting(meeting,admit)
      ranking = Factory.create(:admit_ranking, :faculty => meeting.faculty, :one_on_one => true,:admit => admit)
      meeting.admits = [admit]
      meeting.save!
    end
    before(:each) do
      @faculty = Factory.create(:faculty, :first_name => 'Ras', :last_name => 'Bodik')
      @admit = Factory.create(:admit, :first_name => 'Alan', :last_name => 'Admit')
      @time = Time.parse('1/1/11 11:00') ;  @tm = @time.strftime('%l:%M')
      @faculty.available_times = [Factory.create(:available_time, :begin => @time, :end => @time+20.minutes)]
      @meeting = Factory.create(:meeting, :faculty => @faculty, :time => @time)
    end
    context 'for faculty' do
      it 'occurs if faculty already has a 1-on-1 meeting during same time slot' do
        mary = Factory.create(:admit, :first_name => 'Mary', :last_name => 'Marvel')
        mary.stub!(:available_at?).and_return(true)
        make_one_on_one_meeting(@meeting, mary)
        some_admit = Factory.create(:admit)
        some_admit.stub!(:available_at?).and_return(true)
        @new = Factory.create(:meeting, :time => @time, :faculty => @faculty,
          :admits => [some_admit])
        @new.should_not be_valid
        @new.errors.full_messages.should include('Ras Bodik has a 1-on-1 meeting with Mary Marvel at 11:00.')
      end
      it 'occurs if faculty has max number of admits scheduled during same time slot' do
        @faculty.update_attribute(:max_admits_per_meeting, 3)
        admits = Array.new(4) do |i|
          a = Factory.create(:admit)
          a.stub!(:available_at?).and_return(true)
          a
        end
        @meeting.admits = admits[0..1]
        @meeting.save!
        @new = Factory.create(:meeting, :time => @time, :faculty => @faculty,:admits => admits[2..3])
        @new.should_not be_valid
        @new.errors.full_messages.should include(
          "Ras Bodik is already seeing 3 people at #{@tm}, which is his/her maximum.")
      end
      it 'occurs if faculty is unavailable during that time slot' do
        @meeting.update_attribute(:time, Time.parse('10:00'))
        @meeting.admits = [Factory.create(:admit)]
        @meeting.should_not be_valid
        @meeting.errors.full_messages.should include('Ras Bodik is not available at 10:00.')
      end
      it 'does not occur otherwise' do
        admit = Factory.create(:admit)
        admit.stub!(:available_at?).and_return(true)
        @meeting.admits = [admit]
        @meeting.should be_valid
      end
    end
    context 'for admit' do
      before(:each) do ;  @meeting.admits = [@admit] ; end
      it 'occurs if admit is unavailable during time slot' do
        @meeting.should_not be_valid
        @meeting.errors.full_messages.should include('Alan Admit is not available at 11:00.')
      end
      it 'occurs if admit is already scheduled with another faculty during same time slot' do
        @admit.stub!(:available_at?).and_return(true)
        @meeting.save!
        @new = Factory.create(:meeting, :time => @meeting.time, :faculty => Factory.create(:faculty))
        @new.admits = [@admit]
        @new.should_not be_valid
        @new.errors.full_messages.should include('Alan Admit is already meeting with Ras Bodik at 11:00.')
      end
    end
    it 'occurs if time slot has not been marked as Available by staff'
    it 'does not occur if there is no conflict with staff times, with faculty, or with admit' do
      @admit.stub!(:available_at?).and_return(true)
      @meeting.admits = [@admit]
      @meeting.should be_valid
    end
  end
end
