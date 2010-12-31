class CasExampleController < ApplicationController
  
  def index
    ldap = Net::LDAP.new
    ldap.host = "ldap-test.berkeley.edu"
    filter = Net::LDAP::Filter.eq( "uid", session[:cas_user])
    attrs = []
    
    @ldapparams = Hash.new
    
    ldap.search( :base => "ou=people,dc=berkeley,dc=edu", :filter => filter, :return_result => true ) do |entry|
      
      entry.attribute_names.each do |n|
        @ldapparams[n] = entry[n]
      end
    end
  end

  def logout
    #CASClient::Frameworks::Rails::Filter.logout(self)
    st = session[:cas_last_valid_ticket]
    delete_service_session_lookup(st) if st
    reset_session
    
    protocol = request.ssl? ? 'https://' : 'http://'
    app_url = "localhost:3000/cas_example"
    logout_url = "https://auth-test.berkeley.edu/cas/logout"
    redirect_to("#{logout_url}?url=#{protocol}#{app_url}")    
  end

## The following 2 helper functions copied straight from CASClient::Frameworks::Rails::Filter, b/c they were private methods
  
  # Removes a stored relationship between a ServiceTicket and a local
  # Rails session id. This should be called when the session is being
  # closed.
  #
  # See #store_service_session_lookup.
  def delete_service_session_lookup(st)
    st = st.ticket if st.kind_of? CASClient::ServiceTicket
    ssl_filename = filename_of_service_session_lookup(st)
    File.delete(ssl_filename) if File.exists?(ssl_filename)
  end

  # Returns the path and filename of the service session lookup file.
  def filename_of_service_session_lookup(st)
    st = st.ticket if st.kind_of? CASClient::ServiceTicket
    return "#{RAILS_ROOT}/tmp/sessions/cas_sess.#{st}"
  end
  
end
