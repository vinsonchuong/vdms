module LDAP

  # More stuff related to LDAP searching will be here in the future

  =begin
  def ldap_authenticate
    UCB::LDAP.authenticate("mybind", "mypassword")
  end

  def ldap_deauthenticate
    UCB::LDAP.clear_authentication
  end
=end
  
  def find_ldap_person_entry_by_uid(id)
    return UCB::LDAP::Person.find_by_uid(id)
  end

end

=begin
for reference only


      ldap = Net::LDAP.new
    ldap.host = "ldap-test.berkeley.edu"
    filter = Net::LDAP::Filter.eq( "uid", session[:cas_user])
    attrs = []
    
    @ldapparams = Hash.new
    ldap.search( :base => "ou=people,dc=berkeley,dc=edu", :filter => filter, :return_result => true ) do |entry|
      
      @ldap_entry.attribute_names.each do |n|
        @ldapparams[n] = entry[n]
      end
    end

=end
