require 'casclient/frameworks/rails/filter'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # Ensures logging in with CAS before seeing ANY view at all
  prepend_before_filter CASClient::Frameworks::Rails::Filter

  # Defines the current_user method for use by the CanCan gem  
  def current_user
    # TO BE IMPLEMENTED!!!
    # CAS LDAP ID (session[:cas_user]) is the most consistent way of identification
    # User.find_by_ldap_id(session[:cas_user])
  end

end
