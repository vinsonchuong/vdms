# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Defines the current_user method for use by the CanCan gem
  def current_user
    # TO BE IMPLEMENTED!!!
    # CAS LDAP ID (session[:cas_user]) is the most consistent way of identification
    # User.find_by_ldap_id(session[:cas_user])
    # for now simply set current_user to be session[:cas_user]
    session[:cas_user]
  end
  
  
end
