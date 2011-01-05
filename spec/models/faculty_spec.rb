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

    it 'has a First Name (first_name)' do
      @faculty.should respond_to(:first_name)
      @faculty.should respond_to(:first_name=)
    end

    it 'has a Last Name (last_name)' do
      @faculty.should respond_to(:last_name)
      @faculty.should respond_to(:last_name=)
    end

    it 'has an Email (email)' do
      @faculty.should respond_to(:email)
      @faculty.should respond_to(:email=)
    end

    it 'has an Area (area)' do
      @faculty.should respond_to(:area)
      @faculty.should respond_to(:area=)
    end

    it 'has a Division (division)' do
      @faculty.should respond_to(:division)
      @faculty.should respond_to(:division=)
    end

    it 'has a Schedule (schedule)' do
      @faculty.should respond_to(:schedule)
      @faculty.should respond_to(:schedule=)
    end

    it 'has a Default Room (default_room)' do
      @faculty.should respond_to(:default_room)
      @faculty.should respond_to(:default_room=)
    end

    it 'has a Max Admits Per Meeting preference (max_admits_per_meeting)' do
      @faculty.should respond_to(:max_admits_per_meeting)
      @faculty.should respond_to(:max_admits_per_meeting=)
    end

    it 'has a Max Additional Admits to meet with preference (max_additional_admits)' do
      @faculty.should respond_to(:max_additional_admits)
      @faculty.should respond_to(:max_additional_admits=)
    end
  end

  it 'has an attribute name to accessor map' do
    Faculty::ATTRIBUTES['CalNet ID'].should == :calnet_id
    Faculty::ATTRIBUTES['First Name'].should == :first_name
    Faculty::ATTRIBUTES['Last Name'].should == :last_name
    Faculty::ATTRIBUTES['Email'].should == :email
    Faculty::ATTRIBUTES['Area'].should == :area
    Faculty::ATTRIBUTES['Division'].should == :division
    Faculty::ATTRIBUTES['Schedule'].should == :schedule
    Faculty::ATTRIBUTES['Default Room'].should == :default_room
    Faculty::ATTRIBUTES['Max Admits Per Meeting'].should == :max_admits_per_meeting
    Faculty::ATTRIBUTES['Max Additional Admits'].should == :max_additional_admits
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
