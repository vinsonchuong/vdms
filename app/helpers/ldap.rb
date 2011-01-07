module LDAP

  def find_ldap_person_entry_by_uid(id)
    return UCB::LDAP::Person.find_by_uid(id)
  end
  
  # More stuff related to LDAP searching will be here in the future

  private unless Rails.env == 'test'
  
end
