class ApplicationController < ActionController::Base
  prepend_before_filter RubyCAS::Filter, :unless => Proc.new {@skip_cas}
  before_filter :get_current_user

  protect_from_forgery

  private

  def get_current_user
    unless @skip_cas
      @current_user = Person.find_by_ldap_id(session[:cas_user])
      @current_user = Person.new(:ldap_id => session[:cas_user]) if @current_user.nil?
    end
  end
end
