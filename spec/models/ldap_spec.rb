require 'spec_helper'

describe LDAP do
  before(:each) do
    @entry = mock('Person',
      :uid => '12345',
      :first_name => 'Foo B',
      :last_name => 'BAR',
      :email => 'foo.bar@berkeley.edu',
      :phone => '1234567890',
      :org_node => mock('Org', :description => ['Department']),
      :berkeleyedustuid => 12345678,
      :berkeleyedustuugcode => nil,
      :employee_academic? => false,
      :employee_staff? => false
    )
  end

  it 'finds the right LDAP entry given its UID' do
    UCB::LDAP::Person.should_receive(:find_by_uid).with('12345').and_return(@entry)
    LDAP.find_person('12345')
  end

  it 'returns nil given an invalid UID' do
    UCB::LDAP::Person.stub(:find_by_uid).and_return(nil)
  end

  context 'when finding a the relevant info for a person' do
    it 'returns a hash of all the attributes given the entry has all of the info' do
      LDAP.get_attributes(@entry).should == {
        :uid => '12345',
        :calnet_id => '12345678',
        :first_name => 'Foo B',
        :last_name => 'Bar',
        :email => 'foo.bar@berkeley.edu',
        :phone => '1234567890',
        :department => 'Department'
      }
    end

    it 'returns a hash containing a blank :phone value when the entry lacks a phone' do
      @entry.stub(:phone).and_return(nil)
      LDAP.get_attributes(@entry).should == {
        :uid => '12345',
        :calnet_id => '12345678',
        :first_name => 'Foo B',
        :last_name => 'Bar',
        :email => 'foo.bar@berkeley.edu',
        :phone => '',
        :department => 'Department'
      }
    end

    it 'returns a hash containing a blank :department value when the entry lacks a department' do
      @entry.stub(:org_node).and_return(nil)
      LDAP.get_attributes(@entry).should == {
        :uid => '12345',
        :calnet_id => '12345678',
        :first_name => 'Foo B',
        :last_name => 'Bar',
        :email => 'foo.bar@berkeley.edu',
        :phone => '1234567890',
        :department => ''
      }
    end
  end

  context "when determining a person's role" do
    it "returns :undergrad given an undergraduate student's entry" do
      @entry.stub(:berkeleyedustuugcode).and_return('U')
      LDAP.get_role(@entry).should == :undergrad
    end

    it "returns :grad given an graduate student's entry" do
      @entry.stub(:berkeleyedustuugcode).and_return('G')
      LDAP.get_role(@entry).should == :grad
    end

    it "returns :grad given a GSI's entry" do
      @entry.stub(:berkeleyedustuugcode).and_return('G')
      @entry.stub(:employee_academic?).and_return(true)
      LDAP.get_role(@entry).should == :grad
    end

    it "returns :faculty given a faculty's entry" do
      @entry.stub(:employee_academic?).and_return(true)
      LDAP.get_role(@entry).should == :faculty
    end

    it "returns :staff given a staffs entry" do
      @entry.stub(:employee_staff?).and_return(true)
      LDAP.get_role(@entry).should == :staff
    end
  end
end
