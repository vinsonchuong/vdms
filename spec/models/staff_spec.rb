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

    it 'has a first name (first_name)' do
      @staff.should respond_to(:first_name)
      @staff.should respond_to(:first_name=)
    end

    it 'has a last name (last_name)' do
      @staff.should respond_to(:last_name)
      @staff.should respond_to(:last_name=)
    end

    it 'has an email (email)' do
      @staff.should respond_to(:email)
      @staff.should respond_to(:email=)
    end
  end
end
