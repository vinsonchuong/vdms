require 'spec_helper'

describe PeerAdvisor do
  before(:each) do
    @peer_advisor = Factory.create(:peer_advisor)
  end

  describe 'Attributes' do
    it 'has a CalNet ID (calnet_id)' do
      @peer_advisor.should respond_to(:calnet_id)
      @peer_advisor.should respond_to(:calnet_id=)
    end

    it 'has an LDAP ID (ldap_id)' do
      @peer_advisor.should respond_to(:ldap_id)
      @peer_advisor.should respond_to(:ldap_id=)
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

    it 'has an attribute name to accessor map' do
      PeerAdvisor::ATTRIBUTES['CalNet ID'].should == :calnet_id
      PeerAdvisor::ATTRIBUTES['First Name'].should == :first_name
      PeerAdvisor::ATTRIBUTES['Last Name'].should == :last_name
      PeerAdvisor::ATTRIBUTES['Email'].should == :email
    end

    it 'has an accessor to type map' do
      PeerAdvisor::ATTRIBUTE_TYPES[:calnet_id].should == :string
      PeerAdvisor::ATTRIBUTE_TYPES[:first_name].should == :string
      PeerAdvisor::ATTRIBUTE_TYPES[:last_name].should == :string
      PeerAdvisor::ATTRIBUTE_TYPES[:email].should == :string
    end
  end

  describe 'Associations' do
    it 'has many Admits (admits)' do
      @peer_advisor.should have_many(:admits)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @peer_advisor.should be_valid
    end

    it 'is not valid without an LDAP ID' do
      @peer_advisor.ldap_id = ''
      @peer_advisor.should_not be_valid
    end

    it 'is not valid without a First Name' do
      @peer_advisor.first_name = ''
      @peer_advisor.should_not be_valid
    end

    it 'is not valid without a Last Name' do
      @peer_advisor.last_name = ''
      @peer_advisor.should_not be_valid
    end

    it 'is not valid without an Email' do
      @peer_advisor.email = ''
      @peer_advisor.should_not be_valid
    end

    it 'is not valid with an invalid Email' do
      ['foobar', 'foo@bar', 'foo.com'].each do |invalid_email|
        @peer_advisor.email = invalid_email
        @peer_advisor.should_not be_valid
      end
    end
  end

  context 'when importing a CSV' do
    before(:each) do
      @peer_advisors = Array.new(3) {PeerAdvisor.new}
      new_peer_advisors = @peer_advisors.dup
      PeerAdvisor.stub(:new) do |*args|
        peer_advisor = new_peer_advisors.shift
        peer_advisor.attributes = args[0]
        peer_advisor
      end
    end

    it 'builds a collection of PeerAdvisors with the attributes in each row' do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        CalNet ID,First Name,Last Name,Email
        ID0,First0,Last0,email0@email.com
        ID1,First1,Last1,email1@email.com
        ID2,First2,Last2,email2@email.com
      EOF
      PeerAdvisor.new_from_csv(csv_text).should == @peer_advisors
      @peer_advisors.each_with_index do |peer_advisor, i|
        peer_advisor.calnet_id.should == "ID#{i}"
        peer_advisor.first_name.should == "First#{i}"
        peer_advisor.last_name.should == "Last#{i}"
        peer_advisor.email.should == "email#{i}@email.com"
      end
    end

    it 'ignores extraneous attributes' do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        CalNet ID,Baz,First Name,Last Name,Email,Foo,Bar
        ID0,Baz0,First0,Last0,email0@email.com,Foo0,Bar0
        ID1,Baz1,First1,Last1,email1@email.com,Foo1,Bar1
        ID2,Baz2,First2,Last2,email2@email.com,Foo2,Bar2
      EOF
      PeerAdvisor.new_from_csv(csv_text) == @peer_advisors
      @peer_advisors.each_with_index do |peer_advisor, i|
        peer_advisor.calnet_id.should == "ID#{i}"
        peer_advisor.first_name.should == "First#{i}"
        peer_advisor.last_name.should == "Last#{i}"
        peer_advisor.email.should == "email#{i}@email.com"
      end
    end
  end
end
