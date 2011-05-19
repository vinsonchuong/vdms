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
      @time = Time.zone.parse('1/1/11 11:00') ;  @tm = @time.strftime('%I:%M%p')
      @faculty.available_times = [Factory.create(:available_time, :begin => @time, :end => @time+20.minutes, :available => true)]
      @meeting = Factory.create(:meeting, :faculty => @faculty, :time => @time)
    end
    context 'for faculty' do
      it 'occurs if faculty already has a 1-on-1 meeting during same time slot' do
        pending
        mary = Factory.create(:admit, :first_name => 'Mary', :last_name => 'Marvel')
        mary.stub!(:available_at?).and_return(true)
        make_one_on_one_meeting(@meeting, mary)
        some_admit = Factory.create(:admit)
        some_admit.stub!(:available_at?).and_return(true)
        @new = Factory.create(:meeting, :time => @time, :faculty => @faculty,
          :admits => [some_admit])
        @new.should_not be_valid
        @new.errors.full_messages.should include('Ras Bodik has a 1-on-1 meeting with Mary Marvel at 11:00AM.')
      end
      it 'occurs if faculty has max number of admits scheduled during same time slot' do
        @faculty.update_attribute(:max_admits_per_meeting, 3)
        admits = Array.new(4) do |i|
          a = Factory.create(:admit)
          a.stub!(:available_at?).and_return(true)
          a
        end
        @meeting.admits = admits
        @meeting.should_not be_valid
        @meeting.errors.full_messages.should include(
          "Ras Bodik is already seeing 3 people at #{@tm}, which is his/her maximum.")
      end
      it 'occurs if faculty is unavailable during that time slot' do
        @meeting.update_attribute(:time, Time.zone.parse('10:00'))
        @meeting.admits = [Factory.create(:admit)]
        @meeting.should_not be_valid
        @meeting.errors.full_messages.should include('Ras Bodik is not available at 10:00AM.')
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
        @meeting.errors.full_messages.should include('Alan Admit is not available at 11:00AM.')
      end
      it 'occurs if admit is already scheduled with another faculty during same time slot' do
        @admit.stub!(:available_at?).and_return(true)
        @meeting.save!
        @new = Factory.create(:meeting, :time => @meeting.time, :faculty => Factory.create(:faculty))
        @new.admits = [@admit]
        @new.should_not be_valid
        @new.errors.full_messages.should include('Alan Admit is already meeting with Ras Bodik at 11:00AM.')
      end
    end
    it 'occurs if time slot has not been marked as Available by staff'
    it 'does not occur if there is no conflict with staff times, with faculty, or with admit' do
      @faculty.should be_available_at(@meeting.time)
      @admit.stub!(:available_at?).and_return(true)
      @meeting.admits = [@admit]
      @meeting.should be_valid
    end
  end
  describe 'Deleting admit from a meeting' do
    before(:each) do
      @admit = Factory.create(:admit)
      @admit.stub!(:available_at?).and_return(true)
      @meeting.faculty.stub!(:available_at?).and_return(true)
    end
    it 'should delete if admit is attending meeting' do
      @meeting.admits = [@admit]
      @meeting.save!
      @meeting.remove_admit!(@admit)
      @meeting.admits.should_not include(@admit)
    end
    it 'should be silent if admit is not part of the meeting' do
      lambda { @meeting.remove_admit!(@admit) }.should_not raise_error
    end
  end
  describe 'Adding admit' do
    before(:each) do
      @admit1 = Factory.create(:admit)
      @new_admit = Factory.create(:admit)
      @admit1.stub!(:available_at?).and_return(true)
      @new_admit.stub!(:available_at?).and_return(true)
      @meeting.faculty.stub!(:available_at?).and_return(true)
      @meeting.add_admit!(@admit1)
    end
    describe 'when disallowed', :shared => true do
      it 'should not add the admit to the meeting' do
        @meeting.add_admit!(@new_admit) rescue nil
        @meeting.admits.should_not include(@new_admit)
      end
    end
    context 'if meeting already has max number of admits' do
      before(:each) do
        @meeting.faculty.update_attribute(:max_admits_per_meeting, 1)
      end
      it_should_behave_like 'when disallowed'
      it 'should raise error' do
        lambda { @meeting.add_admit!(@new_admit) }.should raise_error(ActiveRecord::RecordInvalid)
      end
      it 'should provide descriptive error message' do
        @meeting.add_admit!(@new_admit) rescue nil
        @meeting.errors.full_messages.should include("#{@meeting.faculty.full_name} is already seeing 1 people at #{@meeting.time.strftime('%I:%M%p')}, which is his/her maximum.")
      end
    end
    context 'if admit is not available at start time' do
      before(:each) do
        @new_admit.stub!(:available_at?).with(@meeting.time).and_return(nil)
      end
      it_should_behave_like 'when disallowed'
      it 'should raise error' do
        lambda { @meeting.add_admit!(@new_admit) }.
          should raise_error(ActiveRecord::RecordInvalid)
      end
      it 'should provide a descriptive error message' do
        @meeting.add_admit!(@new_admit) rescue nil
        @meeting.errors.full_messages.
          should include("#{@new_admit.full_name} is not available at #{@meeting.time.strftime('%I:%M%p')}.")
      end
    end
    it 'should succeed if admit is available and there is room' do
      @meeting.faculty.update_attribute(:max_admits_per_meeting, 2)
      @meeting.add_admit!(@new_admit)
      lambda { @meeting.save! }.should_not raise_error
      @meeting.admits.should include(@new_admit)
    end
  end
end
