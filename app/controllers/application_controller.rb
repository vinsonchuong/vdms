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
  
  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
  
end
