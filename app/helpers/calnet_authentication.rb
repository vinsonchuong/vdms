module CalNetAuthentication

=begin
  The logout method essentially performs the same procedures as
  CASClient::Frameworks::Rails::Filter.logout(controller),
  with the exception that 
=end
  def logout
    st = session[:cas_last_valid_ticket]
    delete_service_session_lookup(st) if st
    reset_session
    
    protocol = request.ssl? ? 'https://' : 'http://'
    app_url = "localhost:3000/cas_example"
    logout_url = "https://auth-test.berkeley.edu/cas/logout"
    redirect_to("#{logout_url}?url=#{protocol}#{app_url}")    
  end

=begin
  The following 2 helper functions copied straight from
  CASClient::Frameworks::Rails::Filter, b/c they were private methods.
  They are used here instead to accompany the logout method,
  such that the page after logout displays URL link to log back in
=end
  
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
