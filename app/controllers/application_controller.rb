require 'casclient/frameworks/rails/filter'

class ApplicationController < ActionController::Base
  helper :all

# prepend_before_filter CASClient::Frameworks::Rails::Filter
  self.allow_forgery_protection = false

  def current_user
    Person.find_by_calnet_id(session[:cas_user])
  end
end
