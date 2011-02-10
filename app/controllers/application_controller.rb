require 'casclient/frameworks/rails/filter'

class ApplicationController < ActionController::Base
  helper :all
  prepend_before_filter CASClient::Frameworks::Rails::Filter
  
  # Order of these two before_filters is important
  before_filter :get_current_user
  before_filter :create_new_user_if_no_current_user
  
  self.allow_forgery_protection = false

  def get_current_user
    @current_user = Person.find_by_ldap_id(session[:cas_user])
  end

  def get_current_ldap_entry
    LDAPWrapper.find_by_ldap_id(session[:cas_user])
  end
  
  def create_new_user_if_no_current_user
    if @current_user.nil?
      route_to_appropriate_first_time_page
    end
  end
  
  def route_to_appropriate_first_time_page
    model_name = get_current_ldap_entry.model_name
    if model_name.nil? #or model_name == "staff" #UNCOMMENT THIS IN DEPLOYMENT
      render :controller => "root", :action => "access_denied"
    else
      redirect_to :controller => model_name.pluralize, :action => "new"
    end
  end
  
  def get_referrer_action
    request.env['HTTP_REFERER'].gsub(/.*?\/([\w]*?)$/, '\1')
  end
end
