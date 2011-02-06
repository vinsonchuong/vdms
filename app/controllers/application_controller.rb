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
      ldap_person = get_current_ldap_entry
      route_to_appropriate_first_time_page(ldap_person)
    end
  end
  
  def route_to_appropriate_first_time_page(ldap_person)
    model_name = get_model_name_from_ldap_entry(ldap_person)
    if model_name
      redirect_to :controller => model_name, :action => 'new'
    else
      render :controller => "root", :action => "access_denied"
    end
  end
  
  def get_model_name_from_ldap_entry(ldap_person)
    if ldap_person.faculty?
      "faculties"
    elsif ldap_person.grad_student?
      "peer_advisors"
    elsif ldap_person.staff?
      "staffs"
    else
      nil
    end
  end
  
  def get_referrer_action
    request.env['HTTP_REFERER'].gsub(/.*?\/([\w]*?)$/, '\1')
  end
end
