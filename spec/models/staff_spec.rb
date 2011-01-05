require 'spec_helper'

describe Staff do
  describe 'Attributes' do
    before(:each) do
      @staff = Staff.new
    end
    
    it 'has a CalNet ID (calnet_id)' do
      @staff.should respond_to(:calnet_id)
      @staff.should respond_to(:calnet_id=)
    end

    it 'has a First Name (first_name)' do
      @staff.should respond_to(:first_name)
      @staff.should respond_to(:first_name=)
    end

    it 'has a Last Name (last_name)' do
      @staff.should respond_to(:last_name)
      @staff.should respond_to(:last_name=)
    end

    it 'has an Email (email)' do
      @staff.should respond_to(:email)
      @staff.should respond_to(:email=)
    end
  end

  it 'has an attribute name to accessor map' do
    Staff::ATTRIBUTES['CalNet ID'].should == :calnet_id
    Staff::ATTRIBUTES['First Name'].should == :first_name
    Staff::ATTRIBUTES['Last Name'].should == :last_name
    Staff::ATTRIBUTES['Email'].should == :email
  end
end
