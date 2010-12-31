require 'spec_helper'

describe Faculty do
  describe 'Attributes' do
    before(:each) do
      @faculty = Faculty.new
    end

    it 'has a CalNet ID (calnet_id)' do
      @faculty.should respond_to(:calnet_id)
      @faculty.should respond_to(:calnet_id=)
    end

    it 'has a first name (first_name)' do
      @faculty.should respond_to(:first_name)
      @faculty.should respond_to(:first_name=)
    end

    it 'has a last name (last_name)' do
      @faculty.should respond_to(:last_name)
      @faculty.should respond_to(:last_name=)
    end

    it 'has an email (email)' do
      @faculty.should respond_to(:email)
      @faculty.should respond_to(:email=)
    end

    it 'has an area (area)' do
      @faculty.should respond_to(:area)
      @faculty.should respond_to(:area=)
    end

    it 'has a division (division)' do
      @faculty.should respond_to(:division)
      @faculty.should respond_to(:division=)
    end

    it 'has a schedule (schedule)' do
      @faculty.should respond_to(:schedule)
      @faculty.should respond_to(:schedule=)
    end

    it 'has a default room (default_room)' do
      @faculty.should respond_to(:default_room)
      @faculty.should respond_to(:default_room=)
    end

    it 'has a maximum number of students per meeting preference (max_students_per_meeting)' do
      @faculty.should respond_to(:max_students_per_meeting)
      @faculty.should respond_to(:max_students_per_meeting=)
    end

    it 'has a maximum number of additional students to meet with preference (max_additional_students)' do
      @faculty.should respond_to(:max_additional_students)
      @faculty.should respond_to(:max_additional_students=)
    end
  end

  describe 'Associations' do
    before(:each) do
      @faculty = Faculty.new
    end

    it 'has many admit rankings (admit_rankings)' do
      @faculty.should have_many(:admit_rankings)
    end

    it 'has many meetings (meetings)' do
      @faculty.should have_many(:meetings)
    end
  end
end
