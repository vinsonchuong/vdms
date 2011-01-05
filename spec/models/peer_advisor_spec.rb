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

    it 'has a First Name (first_name)' do
      @peer_advisor.should respond_to(:first_name)
      @peer_advisor.should respond_to(:first_name=)
    end

    it 'has a Last Name (last_name)' do
      @peer_advisor.should respond_to(:last_name)
      @peer_advisor.should respond_to(:last_name=)
    end

    it 'has an Email (email)' do
      @peer_advisor.should respond_to(:email)
      @peer_advisor.should respond_to(:email=)
    end
  end

  it 'has an attribute name to accessor map' do
    PeerAdvisor::ATTRIBUTES['CalNet ID'].should == :calnet_id
    PeerAdvisor::ATTRIBUTES['First Name'].should == :first_name
    PeerAdvisor::ATTRIBUTES['Last Name'].should == :last_name
    PeerAdvisor::ATTRIBUTES['Email'].should == :email
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
