class ApplicationController < ActionController::Base
  prepend_before_filter RubyCAS::Filter, :unless => Proc.new {@skip_cas}
  before_filter :get_current_user
  #before_filter :verify_new_user

  protect_from_forgery

  private

  def get_current_user
    unless @skip_cas
      @current_user = Person.find_by_ldap_id(session[:cas_user])
      return unless @current_user.nil?

      entry = LDAP.find_person(session[:cas_user])
      unless entry.nil?
        attributes = {
          :ldap_id => entry[:uid],
          :name => entry[:first_name] + entry[:last_name],
          :email => entry[:email]
        }
        @current_user = (entry[:role] == :faculty) ? Person.new(attributes) :
                        (entry[:role] == :grad) ? Person.new(attributes) :
                        nil
      end
    end
  end

  def verify_new_user
    model_name = @current_user.class.name
    if @current_user.new_record? && !(params[:controller] == model_name.tableize && ['new', 'create'].include?(params[:action]))
      redirect_to(:controller => model_name.tableize, :action => 'new')
    end
  end
end
