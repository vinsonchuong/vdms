require 'casclient/frameworks/rails/filter'

class ApplicationController < ActionController::Base
  helper :all
  prepend_before_filter CASClient::Frameworks::Rails::Filter
  #before_filter :get_current_user
  #before_filter :verify_current_user
  
  
  self.allow_forgery_protection = false

  def get_current_user
    ldap_entry = LDAPWrapper.find_by_ldap_id(session[:cas_user])
    render :controller => "root", :action => "access_denied" if !ldap_entry
    
    @current_user = ldap_entry.model.find_by_ldap_id(session[:cas_user])
    #@current_user = ldap_entry.model.find(:first)
    #puts @current_user.first_name
    ldap_entry.model.new(ldap_entry.attributes).save(false) if (!@current_user and ldap_entry)
    @current_user = ldap_entry.model.find_by_ldap_id(session[:cas_user])
    #@current_user = Person.find(:first)
  end
  
  def verify_current_user
    ldap_entry = LDAPWrapper.find_by_ldap_id(session[:cas_user])
    redirect_to :controller => ldap_entry.model.name.downcase.pluralize, :action => 'edit', :id => @current_user.id if !@current_user.valid?
  end
   
  def get_referrer_action
    request.env['HTTP_REFERER'].gsub(/.*?\/([\w]*?)$/, '\1')
  end
  
end
