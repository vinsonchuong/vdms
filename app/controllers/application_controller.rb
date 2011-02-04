require 'casclient/frameworks/rails/filter'

class ApplicationController < ActionController::Base
  helper :all

  prepend_before_filter CASClient::Frameworks::Rails::Filter
  before_filter :get_current_user
  self.allow_forgery_protection = false

  def get_current_user
    @current_user = Person.find_by_calnet_id(session[:cas_user])
  end

  def get_referrer_action
    request.env['HTTP_REFERER'].gsub(/.*?\/([\w]*?)$/, '\1')
  end
end
