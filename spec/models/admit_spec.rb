require 'spec_helper'

describe Admit do
  describe 'Attributes' do
    before(:each) do
      @admit = Admit.new
    end

    it 'has a CalNet ID (calnet_id)' do
      @admit.should respond_to(:calnet_id)
      @admit.should respond_to(:calnet_id=)
    end

    it 'has a first name (first_name)' do
      @admit.should respond_to(:first_name)
      @admit.should respond_to(:first_name=)
    end

    it 'has a last name (last_name)' do
      @admit.should respond_to(:last_name)
      @admit.should respond_to(:last_name=)
    end

    it 'has an email (email)' do
      @admit.should respond_to(:email)
      @admit.should respond_to(:email=)
    end

    it 'has a phone number (phone)' do
      @admit.should respond_to(:phone)
      @admit.should respond_to(:phone=)
    end

    it 'has a first area (area1)' do
      @admit.should respond_to(:area1)
      @admit.should respond_to(:area1=)
    end

    it 'has a second area (area2)' do
      @admit.should respond_to(:area2)
      @admit.should respond_to(:area2=)
    end

    it 'has an attending flag (attending)' do
      @admit.should respond_to(:attending)
      @admit.should respond_to(:attending=)
    end

    it 'has a list of available meeting times (available_times)' do
      @admit.should respond_to(:available_times)
      @admit.should respond_to(:available_times=)
    end
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
