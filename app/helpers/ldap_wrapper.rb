# need a + and reduce duplicates method for grabbing out all CS and EE people


module LDAPWrapper

  class << self

# Definition: finds an LDAP entry by LDAP ID
# @params: an integer
# @return: an LDAPWrapper::Person object or nil
    def find_by_ldap_id(ldap_id)
      ldap_entry = UCB::LDAP::Person.find_by_uid(ldap_id)
      ldap_entry.nil? ? nil : LDAPWrapper::Person.new(ldap_entry)
    end
    
# Definition: finds an LDAP entry by CalNet ID
# @params: an integer
# @return: an LDAPWrapper::Person object or nil
    def find_by_calnet_id(calnet_id)
      ldap_list = UCB::LDAP::Person.search(:filter => {:berkeleyedustuid => calnet_id})
      ldap_list.empty? ? nil : LDAPWrapper::Person.new(ldap_list[0])
    end
    
# Definition: finds an LDAP entry by berkeley.edu email
# @params: an email string
# @return: an LDAPWrapper::Person object or nil
    def find_by_email(email)
      ldap_list = UCB::LDAP::Person.search(:filter => {:berkeleyeduofficialemail => email}) +
        UCB::LDAP::Person.search(:filter => {:mail => email})
      ldap_list.empty? ? nil : LDAPWrapper::Person.new(ldap_list[0])
    end
    
# Definition: finds LDAP entries by same last name
# @params: a string
# @return: an array of LDAPWrapper::Person objects or and empty array
    def search_by_last_name(last_name)
      ldap_list = UCB::LDAP::Person.search(:filter => {:sn => last_name})
      wrap_ldap_list(ldap_list)
    end

# Definition: finds LDAP entries by same first name
# @params: a string
# @return: an array of LDAPWrapper::Person objects or and empty array
    def search_by_given_name(given_name)
      ldap_list = UCB::LDAP::Person.search(:filter => {:givenname => given_name})
      wrap_ldap_list(ldap_list)
    end
    
# Definition: finds all CS faculty on LDAP
# @params: an integer
# @return: an LDAPWrapper::Person object or nil
    def all_CS_faculty
      ldap_list = UCB::LDAP::Person.search(:filter => {:berkeleyeduprimarydeptunit => 'EH1CS'})
      wrap_ldap_list(ldap_list)
    end
    
# Definition: finds all EE faculty on LDAP
# @params: an integer
# @return: an LDAPWrapper::Person object or nil
    def all_EE_faculty
      ldap_list = UCB::LDAP::Person.search(:filter => {:berkeleyeduprimarydeptunit => 'EH1EE'})
      wrap_ldap_list(ldap_list)
    end
    
    
    private unless Rails.env == 'test'
    
# Definition: wraps UCB::LDAP::Person objects into LDAPWrapper::Person objects
# @params: an array UCB::LDAP::Person objects
# @return: an array LDAPWrapper::Person objects
    def wrap_ldap_list(ldap_list)
      ldap_list.collect{ |person_ldap_entry| LDAPWrapper::Person.new(person_ldap_entry) }
    end

# Definition: remove duplicate LDAPWrapper::Person objects from an array based on their ldap_ids
# @params: an array LDAPWrapper::Person objects
# @return: an LDAPWrapper::Person object
    def remove_duplicates(ldap_people_list)
      reduced_list = []
      uniq_ldap_ids = ldap_people_list.collect{ |person| person.ldap_id }.compact
      ldap_people_list.each do |person|
        if uniq_ldap_ids.include? person.ldap_id
          reduced_list << person
          uniq_ldap_ids.remove(p.ldap_id)
        end
      end
      reduced_list
    end        
  end



  class Person    
    attr_accessor :ldap_entry
    
    def initialize(ldap_entry)
      @ldap_entry = ldap_entry
    end

# Definition: provides attributes for direct import to the Person models
# @params: N/A
# @return: a hash    
    def attributes
      {
        :calnet_id    => self.calnet_id,
        :ldap_id      => self.ldap_id,
        :last_name    => self.last_name,
        :first_name   => self.first_name,
        :email        => self.email,
        :default_room => self.default_room,
        :phone        => self.phone,
        :division     => self.division
      }
    end
    
# Definition: returns the LDAP entry's CalNet ID
# @params: N/A
# @return: a string or nil
    def calnet_id
      calnet_id = @ldap_entry.attributes[:berkeleyedustuid]
      calnet_id.nil? ? nil : calnet_id[0]
    end
    
# Definition: returns the LDAP entry's LDAP ID
# @params: N/A
# @return: a string
    def ldap_id
      @ldap_entry.uid
    end

# Definition: returns the LDAP entry's last name
# @params: N/A
# @return: a string
    def last_name
      @ldap_entry.lastname
    end
    
# Definition: returns the LDAP entry's first name
# @params: N/A
# @return: a string
    def first_name
      @ldap_entry.firstname
    end
    
# Definition: returns the LDAP entry's email
# @params: N/A
# @return: a string
    def email
      ((@ldap_entry.attributes[:berkeleyeduofficialemail] or []) + 
       @ldap_entry.mail)[0]
    end
    
# Definition: returns the LDAP entry's default room
# @params: N/A
# @return: a string or nil
    def default_room
      @ldap_entry.street[0]
    end
    
# Definition: returns the LDAP entry's phone number
# @params: N/A
# @return: a string or nil
    def phone
      @ldap_entry.telephonenumber[0]
    end

# Definition: returns the LDAP entry's EECS division
# @params: N/A
# @return: a string
    def division
      # CODE TABLE BASED ON ALL FACULTY LISTED ON EECS HOME PAGE
      # CAN ALSO BE FOUND UNDER ATTRIBUTE :berkeleyeduunithrdeptname
      # EH1CS - Comp Sci Div Operations
      # EH1EE - Elect Eng Div Operations
      # EH1EO - EECS Dept Operations" - mostly staff
      # EERES - COENG Engineering Research - ex Lisa Fowler and Armando Fox - over 500 entries
      # EF1BO - BIOE Dept Operations
      # MMIMS - School of Information
      # IBIBI - Integrative Biology
      # EIIEO - Industrial Eng & Ops Res
      # SYPSY - Psychology

      case @ldap_entry.dept_code
      when 'EH1CS' then 'Computer Science'
      when 'EH1EE' then 'Electrical Engineering'
      when 'EH1EO' then 'EECS Department Staff'
      when 'EERES' then 'COENG Engineering Research'
      when 'EF1BO' then 'Bioengineering'
      when 'MMIMS' then 'School of Information'
      else "Other department: #{@ldap_entry.dept_name or @ldap_entry.berkeleyeduunithrdeptname}, Code #<#{@ldap_entry.dept_code}>"
      end
    end
    
# Definition: determines whether an LDAP entry belongs to that of an undergrad student
# @params: N/A
# @return: a boolean
    def undergrad_student?
      @ldap_entry.berkeleyedustuugcode == "U"
    end

# Definition: determines whether an LDAP entry belongs to that of an grad student
# @params: N/A
# @return: a boolean
    def grad_student?
      @ldap_entry.berkeleyedustuugcode == "G"
    end

# Definition: determines whether an LDAP entry belongs to that of a UCB faculty
# @params: N/A
# @return: a boolean
    def faculty?
      @ldap_entry.employee_academic?
    end

# Definition: determines whether an LDAP entry belongs to that of a UCB staff
    # @params: N/A
# @return: a boolean
    def staff?
      @ldap_entry.employee_staff?
    end    

# Definition: returns the LDAP entry's corresponding VDMS model name
# @params: N/A
# @return: a string
    def model_name
      if faculty?
        "faculty"
      elsif grad_student?
        "peer_advisor"
      elsif staff?
        "staff"
      else
        nil
      end
    end    
  end  
  
end
