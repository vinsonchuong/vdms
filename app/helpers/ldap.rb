module LDAP
  # Stuff related to LDAP searching will be here in the future
  def find_ldap_person_entry_by_uid(id)
    return UCB::LDAP::Person.find_by_uid(id)
  end
  
end
