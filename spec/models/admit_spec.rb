require 'spec_helper'

describe Admit do
  describe 'Attributes' do
    before(:each) do
      @admit = Admit.new
    end

    it 'has a First Name (first_name)' do
      @admit.should respond_to(:first_name)
      @admit.should respond_to(:first_name=)
    end

    it 'has a Last Name (last_name)' do
      @admit.should respond_to(:last_name)
      @admit.should respond_to(:last_name=)
    end

    it 'has an Email (email)' do
      @admit.should respond_to(:email)
      @admit.should respond_to(:email=)
    end

    it 'has a Phone (phone)' do
      @admit.should respond_to(:phone)
      @admit.should respond_to(:phone=)
    end

    it 'has an Area 1 (area1)' do
      @admit.should respond_to(:area1)
      @admit.should respond_to(:area1=)
    end

    it 'has an Area 2 (area2)' do
      @admit.should respond_to(:area2)
      @admit.should respond_to(:area2=)
    end

    it 'has an Attending flag (attending)' do
      @admit.should respond_to(:attending)
      @admit.should respond_to(:attending=)
    end

    it 'has a list of Available Times (available_times)' do
      @admit.should respond_to(:available_times)
      @admit.should respond_to(:available_times=)
    end
  end

  it 'has an attribute name to accessor map' do
    Admit::ATTRIBUTES['CalNet ID'].should == :calnet_id
    Admit::ATTRIBUTES['First Name'].should == :first_name
    Admit::ATTRIBUTES['Last Name'].should == :last_name
    Admit::ATTRIBUTES['Email'].should == :email
    Admit::ATTRIBUTES['Phone'].should == :phone
    Admit::ATTRIBUTES['Area 1'].should == :area1
    Admit::ATTRIBUTES['Area 2'].should == :area2
    Admit::ATTRIBUTES['Attending'].should == :attending
    Admit::ATTRIBUTES['Available Times'].should == :available_times
  end

  describe 'Associations' do
    before(:each) do
      @admit = Admit.new
    end

    it 'belongs to a peer advisor (peer_advisor)' do
      @admit.should belong_to(:peer_advisor)
    end

    it 'has many faculty rankings (faculty_rankings)' do
      @admit.should have_many(:faculty_rankings)
    end

    it 'has and belongs to many meetings (meetings)' do
      @admit.should have_and_belong_to_many(:meetings)
    end
  end
end
