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
  
  def index
    @ldap_entry = find_ldap_person_entry_by_uid(session[:cas_user])
    @ldapparams = @ldap_entry.attributes
  end
  
end
