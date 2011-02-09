require 'spec_helper'

describe LDAPWrapper do

  describe "LDAPWrapper methods" do

    describe 'module method: find_by_ldap_id' do
      before(:each) do
        @ldap_entry = mock("LDAP Entry")
        @id = rand(10000000)
        UCB::LDAP::Person.stub!(:find_by_uid).and_return(@ldap_entry)
      end
      
      it "should return LDAPWrapper::Person with the correct LDAP ID if it's present in the directory" do
        @result = LDAPWrapper.find_by_ldap_id(@id)
        @result.class.should == LDAPWrapper::Person
        @result.ldap_entry.should == @ldap_entry
      end
      
      it "should use the underlying API provided by UCB::LDAP::Person to help search the LDAP entry" do
        UCB::LDAP::Person.should_receive(:find_by_uid).once.with(@id)
        LDAPWrapper.find_by_ldap_id(@id)
      end
    end

    describe 'module method: find_by_calnet_id' do
      before(:each) do
        @ldap_entry = mock("LDAP Entry")
        @id = rand(10000000)
        UCB::LDAP::Person.stub!(:search).and_return([@ldap_entry])
      end
      
      it "should return LDAPWrapper::Person with the correct CalNet ID if it's present in the directory" do
        @result = LDAPWrapper.find_by_calnet_id(@id)
        @result.class.should == LDAPWrapper::Person
        @result.ldap_entry.should == @ldap_entry
      end
      
      it "should use the underlying API provided by UCB::LDAP::Person correctly to help search the LDAP entry" do        
        UCB::LDAP::Person.should_receive(:search).once
        LDAPWrapper.find_by_calnet_id(@id)
      end
    end

    describe 'module method: find_by_email' do
      before(:each) do
        @ldap_entry = mock("LDAP Entry")
        @email = (('A'..'Z').collect + ('0'..'9').collect + ['.','@']).shuffle.shuffle.join
        UCB::LDAP::Person.stub!(:search).and_return([@ldap_entry])
      end
      
      it "should return LDAPWrapper::Person with the correct CalNet ID if it's present in the directory" do
        @result = LDAPWrapper.find_by_email(@email)
        @result.class.should == LDAPWrapper::Person
        @result.ldap_entry.should == @ldap_entry
      end
      
      it "should use the underlying API provided by UCB::LDAP::Person correctly to help search the LDAP entry" do
        UCB::LDAP::Person.should_receive(:search).once
        LDAPWrapper.find_by_email(@email)
      end
    end

    describe 'module method: search_by_last_name' do
      before(:each) do
        @ldap_entry = mock("LDAP Entry")
        @last_name = ([('A'..'Z').collect.sample] + ('a'..'z').collect.shuffle.shuffle).join
        UCB::LDAP::Person.stub!(:search).and_return([@ldap_entry])
      end

      it "should call wrap the results into LDAPWrapper::Person objects" do
        LDAPWrapper.should_receive(:wrap_ldap_list).once
        LDAPWrapper.search_by_last_name(@last_name)
      end
      
      it "should return LDAPWrapper::Person with the correct CalNet ID if it's present in the directory" do
        @results = LDAPWrapper.search_by_last_name(@last_name)
        @results.class.should == Array
        @results[0].class.should == LDAPWrapper::Person
        @results[0].ldap_entry.should == @ldap_entry
      end
      
      it "should use the underlying API provided by UCB::LDAP::Person correctly to help search the LDAP entry" do
        UCB::LDAP::Person.should_receive(:search).once
        LDAPWrapper.search_by_last_name(@last_name)
      end
    end
    
    describe 'module method: search_by_given_name' do
      before(:each) do
        @ldap_entry = mock("LDAP Entry")
        @given_name = ([('A'..'Z').collect.sample] + ('a'..'z').collect.shuffle.shuffle).join
        UCB::LDAP::Person.stub!(:search).and_return([@ldap_entry])
      end

      it "should call wrap the results into LDAPWrapper::Person objects" do
        LDAPWrapper.should_receive(:wrap_ldap_list).once
        LDAPWrapper.search_by_given_name(@last_name)
      end
      
      it "should return LDAPWrapper::Person with the correct CalNet ID if it's present in the directory" do
        @results = LDAPWrapper.search_by_given_name(@last_name)
        @results[0].class.should == LDAPWrapper::Person
        @results[0].ldap_entry.should == @ldap_entry
      end
      
      it "should use the underlying API provided by UCB::LDAP::Person correctly to help search the LDAP entry" do
        UCB::LDAP::Person.should_receive(:search).once
        LDAPWrapper.search_by_given_name(@first_name)
      end
    end

    describe 'module method: all_CS_faculty' do      
      it "should call wrap the results into LDAPWrapper::Person objects" do
        LDAPWrapper.should_receive(:wrap_ldap_list).once
        LDAPWrapper.all_CS_faculty
      end
      
      it "should use the underlying API provided by UCB::LDAP::Person correctly to help search the LDAP entry" do
        UCB::LDAP::Person.should_receive(:search).once.and_return []
        LDAPWrapper.all_CS_faculty
      end
    end
    
    describe 'module method: all_EE_faculty' do
      it "should call wrap the results into LDAPWrapper::Person objects" do
        LDAPWrapper.should_receive(:wrap_ldap_list).once
        LDAPWrapper.all_EE_faculty
      end
      
      it "should use the underlying API provided by UCB::LDAP::Person correctly to help search the LDAP entry" do
        UCB::LDAP::Person.should_receive(:search).once.and_return []
        LDAPWrapper.all_EE_faculty
      end
    end
  end

  describe LDAPWrapper::Person do
    describe 'instance method: attributes' do
      it "should return the proper attributes hash" do
        @calnet_id = rand(10000000).to_s
        @ldap_id = rand(10000000).to_s
        @last_name = ([('A'..'Z').collect.sample] + ('a'..'z').collect.shuffle.shuffle).join
        @first_name = ([('A'..'Z').collect.sample] + ('a'..'z').collect.shuffle.shuffle).join
        @email = (('A'..'Z').collect + ('0'..'9').collect + ['.','@']).shuffle.shuffle.join
        @default_room = (('A'..'Z').collect + (0..9).collect).shuffle.shuffle.join
        @phone = rand(1000000000).to_s
        @division = ([('A'..'Z').collect.sample] + ('a'..'z').collect.shuffle.shuffle).join
        @ldap_entry = mock("LDAP Entry")
        
        @person = LDAPWrapper::Person.new(@ldap_entry)
        @person.stub!(:calnet_id).and_return(@calnet_id)
        @person.stub!(:ldap_id).and_return(@ldap_id)
        @person.stub!(:last_name).and_return(@last_name)
        @person.stub!(:first_name).and_return(@first_name)
        @person.stub!(:email).and_return(@email)
        @person.stub!(:default_room).and_return(@default_room)
        @person.stub!(:phone).and_return(@phone)
        @person.stub!(:division).and_return(@division)
        @person.attributes.should == {
          :calnet_id    => @calnet_id,
          :ldap_id      => @ldap_id,
          :last_name    => @last_name,
          :first_name   => @first_name,
          :email        => @email,
          :default_room => @default_room,
          :phone        => @phone,
          :division     => @division
        }
      end
    end

    describe 'instance method: calnet_id' do
      it "should return the LDAP entry's CalNet ID if it's present" do
        @calnet_id = rand(10000000).to_s
        @ldap_entry = mock("LDAP Entry", :attributes => { :berkeleyedustuid => [@calnet_id] })
        LDAPWrapper::Person.new(@ldap_entry).calnet_id.should == @calnet_id
      end
    end
    
    describe 'instance method: ldap_id' do
      it "should return the LDAP entry's LDAP ID using the underlying API provided by UCB::LDAP::Person" do
        @ldap_id = rand(10000000).to_s
        @ldap_entry = mock("LDAP Entry", :uid => @ldap_id)
        @ldap_entry.should_receive(:uid).once
        LDAPWrapper::Person.new(@ldap_entry).ldap_id.should == @ldap_id
      end
    end
    
    describe 'instance method: last_name' do
      it "should return the LDAP entry's last name using the underlying API provided by UCB::LDAP::Person" do
        @last_name = ([('A'..'Z').collect.sample] + ('a'..'z').collect.shuffle.shuffle).join
        @ldap_entry = mock("LDAP Entry", :lastname => @last_name)
        @ldap_entry.should_receive(:lastname).once
        LDAPWrapper::Person.new(@ldap_entry).last_name.should == @last_name
      end
    end

    describe 'instance method: first_name' do
      it "should return the LDAP entry's first name using the underlying API provided by UCB::LDAP::Person" do
        @first_name = ([('A'..'Z').collect.sample] + ('a'..'z').collect.shuffle.shuffle).join
        @ldap_entry = mock("LDAP Entry", :firstname => @first_name)
        @ldap_entry.should_receive(:firstname).once
        LDAPWrapper::Person.new(@ldap_entry).first_name.should == @first_name
      end
    end
    
    describe 'instance method: email' do
      before(:each) do
        @email = (('A'..'Z').collect + ('0'..'9').collect + ['.','@']).shuffle.shuffle.join
      end
      
      it "should return the LDAP entry's berkeley.edu email if present" do
        @attributes = { :berkeleyeduofficialemail => [@email] }
        @ldap_entry = mock("LDAP Entry", :attributes => @attributes, :mail => [])        
        LDAPWrapper::Person.new(@ldap_entry).email.should == @email
      end

      it "should return the LDAP entry's mail attribute if the berkeley.edu email is not present" do
        @ldap_entry = mock("LDAP Entry", :attributes => {}, :mail => [@email])
        LDAPWrapper::Person.new(@ldap_entry).email.should == @email
      end
      
      it "should return nil if the LDAP entry contains no email entry at all" do
        @ldap_entry = mock("LDAP Entry", :attributes => {}, :mail => [])
        LDAPWrapper::Person.new(@ldap_entry).email.should == nil
      end
    end
    
    describe 'instance method: default_room' do
      it "should return the LDAP entry's address if present" do   
        @address = (('A'..'Z').collect + (0..9).collect).shuffle.shuffle.join
        @ldap_entry = mock("LDAP Entry", :street => [@address])
        LDAPWrapper::Person.new(@ldap_entry).default_room.should == @address
        LDAPWrapper::Person.new(@ldap_entry).default_room.class.should == String
      end
      
      it "should return nil if the LDAP entry contains no address" do
        @ldap_entry = mock("LDAP Entry", :street => [])
        LDAPWrapper::Person.new(@ldap_entry).default_room.should == nil
      end
    end

    describe 'instance method: phone' do
      it "should return the LDAP entry's phone number if it's present" do   
        @phone_num = rand(100000000000).to_s
        @ldap_entry = mock("LDAP Entry", :telephonenumber => [@phone_num])
        LDAPWrapper::Person.new(@ldap_entry).phone.should == @phone_num
        LDAPWrapper::Person.new(@ldap_entry).phone.class.should == String
      end
      
      it "should return nil if the LDAP entry contains no phone number" do   
        @ldap_entry = mock("LDAP Entry", :telephonenumber => [])
        LDAPWrapper::Person.new(@ldap_entry).phone.should == nil
      end
    end

    describe 'instance method: division' do
    end

    describe 'instance method: undergrad_student?' do
      it "should return true if LDAP entry is that of a UCB undergraduate student" do
        @ldap_entry = mock("LDAP Entry", :berkeleyedustuugcode => 'U')
        LDAPWrapper::Person.new(@ldap_entry).undergrad_student?.should == true
      end
      
      it "should return false if the LDAP entry is that of a non-undergraduate-student" do   
        @ldap_entry = mock("LDAP Entry", :berkeleyedustuugcode => ('A'..'Z').collect.delete_if{ |p| p == 'U'}.sample)
        LDAPWrapper::Person.new(@ldap_entry).undergrad_student?.should == false
      end
    end
    
    describe 'instance method: grad_student?' do
      it "should return true if LDAP entry is that of a UCB graduate student" do
        @ldap_entry = mock("LDAP Entry", :berkeleyedustuugcode => 'G')
        LDAPWrapper::Person.new(@ldap_entry).grad_student?.should == true
      end
      
      it "should return false if the LDAP entry is that of a non-graduate-student" do   
        @ldap_entry = mock("LDAP Entry", :berkeleyedustuugcode => ('A'..'Z').collect.delete_if{ |p| p == 'G'}.sample)
        LDAPWrapper::Person.new(@ldap_entry).grad_student?.should == false
      end
    end
    
    describe 'instance method: faculty?' do
      it "should return true if LDAP entry is that of a UCB faculty" do
        @ldap_entry = mock("LDAP Entry", :employee_academic? => true)
        LDAPWrapper::Person.new(@ldap_entry).faculty?.should == true
      end
      
      it "should return false if the LDAP entry is that of a non-faculty" do   
        @ldap_entry = mock("LDAP Entry", :employee_academic? => false)
        LDAPWrapper::Person.new(@ldap_entry).faculty?.should == false
      end
    end

    describe 'instance method: staff?' do
      it "should return true if LDAP entry is that of a UCB staff" do
        @ldap_entry = mock("LDAP Entry", :employee_staff? => true)
        LDAPWrapper::Person.new(@ldap_entry).staff?.should == true
      end
      
      it "should return false if the LDAP entry is that of a non-staff" do   
        @ldap_entry = mock("LDAP Entry", :employee_staff? => false)
        LDAPWrapper::Person.new(@ldap_entry).staff?.should == false
      end
    end
    
    describe 'instance method: model_name' do
      before(:each) do
        @ldap_entry = mock("LDAP Entry")
        @ldap_person = LDAPWrapper::Person.new(@ldap_entry)        
      end
      
      it "should return \'faculty\' if the LDAP entry is that of a faculty" do
        @ldap_person.stub!(:faculty?).and_return(true)
        @ldap_person.stub!(:grad_student?).and_return(false)
        @ldap_person.stub!(:staff?).and_return(false)
        @ldap_person.model_name.should == "faculty"
      end

      it "should return \'peer_advisor\' if the LDAP entry is that of a grad student" do
        @ldap_person.stub!(:faculty?).and_return(false)
        @ldap_person.stub!(:grad_student?).and_return(true)
        @ldap_person.stub!(:staff?).and_return(false)
        @ldap_person.model_name.should == "peer_advisor"
      end

      it "should return \'staff\' if the LDAP entry is that of a staff" do
        @ldap_person.stub!(:faculty?).and_return(false)
        @ldap_person.stub!(:grad_student?).and_return(false)
        @ldap_person.stub!(:staff?).and_return(true)
        @ldap_person.model_name.should == "staff"
      end

      it "should return nil if the LDAP entry is that of an undergrad or some other Berkeley affiliate" do
        @ldap_person.stub!(:faculty?).and_return(false)
        @ldap_person.stub!(:grad_student?).and_return(false)
        @ldap_person.stub!(:staff?).and_return(false)
        @ldap_person.model_name.should == nil
      end
    end

  end
end
