require 'spec_helper'

describe PeerAdvisor do
  describe 'Attributes' do
    before(:each) do
      @peer_advisor = PeerAdvisor.new
    end
    
    it 'has a CalNet ID (calnet_id)' do
      @peer_advisor.should respond_to(:calnet_id)
      @peer_advisor.should respond_to(:calnet_id=)
    end

    it 'has a first name (first_name)' do
      @peer_advisor.should respond_to(:first_name)
      @peer_advisor.should respond_to(:first_name=)
    end

    it 'has a last name (last_name)' do
      @peer_advisor.should respond_to(:last_name)
      @peer_advisor.should respond_to(:last_name=)
    end

    it 'has an email (email)' do
      @peer_advisor.should respond_to(:email)
      @peer_advisor.should respond_to(:email=)
    end
  end

  describe 'Associations' do
    before(:each) do
      @peer_advisor = PeerAdvisor.new
    end

    it 'has many admits (admits)' do
      @peer_advisor.should have_many(:admits)
    end
  end
end
