# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Defines the current_user method for use by the CanCan gem
  def current_user
    # TO BE IMPLEMENTED!!
    # CAS LDAP ID (session[:cas_user]) is the msot consistent way of indentification
    # User.find_by_ldap_id(session[:cas_user])
    # for now just return session[:cas_user]
    
    session[:cas_user]
    #@current_user = find_ldap_person_entry_by_uid(session[:cas_user])
  end
    
end
