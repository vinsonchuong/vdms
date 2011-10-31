require 'spec_helper'

describe Person do
  before(:each) do
    @person = Factory.create(:person)
  end

  describe 'Attributes' do
    it 'has an LDAP ID (ldap_id)' do
      @person.should respond_to(:ldap_id)
      @person.should respond_to(:ldap_id=)
    end

    it 'has a Name (name)' do
      @person.should respond_to(:name)
      @person.should respond_to(:name=)
    end

    it 'has an Email (email)' do
      @person.should respond_to(:email)
      @person.should respond_to(:email=)
    end

    it 'has a Role (role)' do
      @person.should respond_to(:role)
      @person.should respond_to(:role=)
    end

    it 'has a Division (division)' do
      @person.should respond_to(:division)
      @person.should respond_to(:division=)
    end

    it 'has an Area 1 (area_1)' do
      @person.should respond_to(:area_1)
      @person.should respond_to(:area_1=)
    end

    it 'has an Area 2 (area_2)' do
      @person.should respond_to(:area_2)
      @person.should respond_to(:area_2=)
    end

    it 'has an Area 3 (area_3)' do
      @person.should respond_to(:area_3)
      @person.should respond_to(:area_3=)
    end
  end

  describe 'Associations' do
    it 'has many Event Roles (event_role)' do
      @person.should have_many(:event_roles)
    end

    it 'has many Events through Event Roles (events)' do
      @person.should have_many(:events).through(:event_roles)
    end
  end

  describe 'Named Scopes' do
    it 'is sorted by Name' do
      @person.update_attributes(:name => 'Aaa')
      Factory.create(:person, :name => 'Ccc')
      Factory.create(:person, :name => 'Bbb')
      Factory.create(:person, :name => 'Aaa')
      Person.all.map(&:name).should == ['Aaa', 'Aaa', 'Bbb', 'Ccc']
    end

    it 'has a list of People with the given Areas (with_areas)' do
      # Areas are set at runtime and cannot be stubbed
      @person.update_attributes(:name => 'Aaa', :area_1 => 'ai')
      Factory.create(:person, :name => 'Ccc', :area_1 => 'ai', :area_2 => 'bio')
      Factory.create(:person, :name => 'Bbb', :area_1 => 'bio', :area_2 => 'cir')
      Factory.create(:person, :name => 'Ddd', :area_1 => 'ai', :area_2 => 'bio', :area_3 => 'cir')

      Person.with_areas('ai').map(&:name).should == ['Aaa', 'Ccc', 'Ddd']
      Person.with_areas('ai', 'bio').map(&:name).should == ['Aaa', 'Bbb', 'Ccc', 'Ddd']
      Person.with_areas('cir').map(&:name).should == ['Bbb', 'Ddd']
    end
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      @person.should be_valid
    end

    it 'is not valid without a Name' do
      @person.name = ''
      @person.should_not be_valid
      @person.errors.full_messages.should include("Name can't be blank")
    end

    it 'is valid with a valid Email' do
      ['foobar@foobar.com'].each do |email|
        @person.email = email
        @person.should be_valid
      end
    end

    it 'is not valid with an invalid Email' do
      ['foobar', 'foo@bar', 'foo.com'].each do |invalid_email|
        @person.email = invalid_email
        @person.should_not be_valid
        @person.errors.full_messages.should include("Email is invalid")
      end
    end

    it 'is valid with a valid Role' do
      ['user', 'facilitator', 'administrator'].each do |role|
        @person.role = role
        @person.should be_valid
      end
    end

    it 'is not valid with an invalid Role' do
      ['foo', '', 123].each do |invalid_role|
        @person.role = invalid_role
        @person.should_not be_valid
        @person.errors.full_messages.should include("Role is invalid")
      end
    end

    it 'is valid with a valid Division' do
      (Person.divisions.map(&:last) << '').each do |division|
        @person.division = division
        @person.should be_valid
      end
    end

    it 'is not valid with an invalid Division' do
      ['Division 3', 123].each do |invalid_division|
        @person.division = invalid_division
        @person.should_not be_valid
        @person.errors.full_messages.should include("Division is invalid")
      end
    end

    it 'is valid with a valid Area 1' do
      (Person.areas.map(&:last) << '').each do |area|
        @person.area_1 = area
        @person.should be_valid
      end
    end

    it 'is not valid with an invalid Area 1' do
      ['Area 3', 123].each do |invalid_area|
        @person.area_1 = invalid_area
        @person.should_not be_valid
        @person.errors.full_messages.should include("Area 1 is invalid")
      end
    end

    it 'is valid with a valid Area 2' do
      (Person.areas.map(&:last) << '').each do |area|
        @person.area_2 = area
        @person.should be_valid
      end
    end

    it 'is not valid with an invalid Area 2' do
      ['Area 3', 123].each do |invalid_area|
        @person.area_2 = invalid_area
        @person.should_not be_valid
        @person.errors.full_messages.should include("Area 2 is invalid")
      end
    end

    it 'is valid with a valid Area 3' do
      (Person.areas.map(&:last) << '').each do |area|
        @person.area_3 = area
        @person.should be_valid
      end
    end

    it 'is not valid with an invalid Area 3' do
      ['Area 3', 123].each do |invalid_area|
        @person.area_3 = invalid_area
        @person.should_not be_valid
        @person.errors.full_messages.should include("Area 3 is invalid")
      end
    end
  end

  describe 'after validating' do
    it 'maps Areas to their canonical form' do
      Person.stub(:areas).and_return('A1' => 'Area 1', 'A2' => 'Area 2')
      [['A1', 'A1'], ['Area 1', 'A1'], ['', '']].each do |area, canonical|
        @person.area_1 = area
        @person.area_2 = area
        @person.area_3 = area
        @person.valid?
        @person.area_1.should == canonical
        @person.area_2.should == canonical
        @person.area_3.should == canonical
      end
    end

    it 'maps Division to its canonical form' do
      Person.stub(:divisions).and_return('D1' => 'Division 1', 'D2' => 'Division 2')
      [['D1', 'D1'], ['Division 1', 'D1'], ['', '']].each do |division, canonical|
        @person.division = division
        @person.valid?
        @person.division.should == canonical
      end
    end
  end
end
