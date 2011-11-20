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
  end
end
