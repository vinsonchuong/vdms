require 'spec_helper'

describe Person do
  describe 'Attributes' do
    before(:each) do
      @person = Person.new
    end
    
    it 'has a CalNet ID (calnet_id)' do
      @person.should respond_to(:calnet_id)
      @person.should respond_to(:calnet_id=)
    end

    it 'has a first name (first_name)' do
      @person.should respond_to(:first_name)
      @person.should respond_to(:first_name=)
    end

    it 'has a last name (last_name)' do
      @person.should respond_to(:last_name)
      @person.should respond_to(:last_name=)
    end

    it 'has an email (email)' do
      @person.should respond_to(:email)
      @person.should respond_to(:email=)
    end
  end
end
