require 'casclient/frameworks/rails/filter'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user # make current_user a helper method, which can be called from views
  before_filter CASClient::Frameworks::Rails::Filter  # Ensures logging in with CAS before seeing ANY view at all
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # Defines the current_user method for use by the CanCan gem
  def current_user
    # TO BE IMPLEMENTED!!!
    # CAS LDAP ID (session[:cas_user]) is the most consistent way of identification
    # User.find_by_ldap_id(session[:cas_user])
    # for now simply set current_user to be session[:cas_user]
    session[:cas_user]
  end
  
  
  # This index function has be take off from cas_example_controller. Nothing has been modified.
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
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
  
end
