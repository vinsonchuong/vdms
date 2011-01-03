require 'casclient/frameworks/rails/filter'
require 'calnet_authentication'
require 'ldap'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include CalNetAuthentication
  include LDAP

  helper :all # include all helpers, all the time
  prepend_before_filter CASClient::Frameworks::Rails::Filter  # Ensures logging in with CAS before seeing ANY view at all
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # This index function has be take off from cas_example_controller. Nothing has been modified.
  def index
    ldap = Net::LDAP.new
    ldap.host = "ldap-test.berkeley.edu"
    filter = Net::LDAP::Filter.eq( "uid", session[:cas_user])
    #attrs = []
    
    @ldapparams = Hash.new
    ldap.search( :base => "ou=people,dc=berkeley,dc=edu", :filter => filter, :return_result => true ) do |entry|      
      entry.attribute_names.each do |n|
        @ldapparams[n] = entry[n]
      end
    end
  end
  
  def index
    @ldap_entry = find_ldap_person_entry_by_uid(session[:cas_user])
    @ldapparams = @ldap_entry.attributes
  end
  
end
